module Bigcommerce
  module Lightstep
    ##
    # Helper module that can be included into Rails controllers to automatically instrument them with LightStep
    #
    module RailsControllerInstrumentation
      OPEN_TRACING_HEADER_KEYS = %w[ot-tracer-traceid ot-tracer-spanid ot-tracer-sampled].freeze

      def self.included(base)
        base.send(:around_action, :lightstep_trace)
      end

      protected

      ##
      # Trace the controller method
      #
      def lightstep_trace
        prefix = ::Bigcommerce::Lightstep.controller_trace_prefix
        key = "#{prefix}#{controller_name}.#{action_name}"
        headers = lightstep_filtered_headers
        tracer = ::Bigcommerce::Lightstep::Tracer.instance
        result = tracer.start_span(key, context: headers) do |span|
          span.set_tag('controller.name', controller_name)
          span.set_tag('action.name', action_name)
          span.set_tag('http.url', request.original_url.split('?').first)
          span.set_tag('http.method', request.method)
          span.set_tag('http.content_type', request.format)
          span.set_tag('http.host', request.host)
          begin
            resp = yield
          rescue StandardError => _
            span.set_tag('error', true)
            span.set_tag('http.status_code', Bigcommerce::Lightstep.http1_error_code)
            tracer.clear_active_span!
            span.finish
            raise # re-raise the error
          end
          span.set_tag('http.status_code', response.status)
          # 400+ HTTP status codes are errors: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
          span.set_tag('error', true) if response.status >= Bigcommerce::Lightstep.http1_error_code_minimum
          resp
        end
        tracer.clear_active_span!
        result
      end

      ##
      # Get only the open tracing headers
      #
      # @return [Hash]
      #
      def lightstep_filtered_headers
        filtered_ot_headers = {}
        headers = request.headers.to_h
        headers.each do |k, v|
          fk = k.to_s.downcase.gsub('http_', '').tr('_', '-')
          next unless OPEN_TRACING_HEADER_KEYS.include?(fk)
          filtered_ot_headers[fk] = v
        end
        filtered_ot_headers
      end
    end
  end
end

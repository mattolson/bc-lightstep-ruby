# Copyright (c) 2018-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
module Bigcommerce
  module Lightstep
    ##
    # Build transports for the lightstep connection
    #
    class TransportFactory
      ##
      # @return [::Bigcommerce::Lightstep::Transport]
      #
      def build
        ::Bigcommerce::Lightstep::Transport.new(
          host: ::Bigcommerce::Lightstep.host,
          port: ::Bigcommerce::Lightstep.port.to_i,
          verbose: ::Bigcommerce::Lightstep.verbosity.to_i,
          encryption: ::Bigcommerce::Lightstep.port.to_i == 443 ? ::Bigcommerce::Lightstep::Transport::ENCRYPTION_TLS : ::Bigcommerce::Lightstep::Transport::ENCRYPTION_NONE,
          ssl_verify_peer: ::Bigcommerce::Lightstep.ssl_verify_peer,
          access_token: ::Bigcommerce::Lightstep.access_token,
          logger: ::Bigcommerce::Lightstep.logger
        )
      end
    end
  end
end

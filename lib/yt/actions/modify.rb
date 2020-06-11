require 'yt/request'
require 'yt/actions/base'
require 'yt/config'

module Yt
  module Actions
    # Abstract module that contains methods common to Delete and Update
    module Modify
      include Base

    private

      def do_modify(params = {})
        response = modify_request(params).run
        yield response.body if block_given?
      end

      def modify_request(params = {})
        Yt::Request.new(params).tap do |request|
          print "#{request.as_curl}\n" if Yt.configuration.developing?
        end
      end

      def modify_params
        path = "/youtube/v3/#{self.class.to_s.demodulize.pluralize.camelize :lower}"

        {}.tap do |params|
          params[:path] = path
          params[:auth] = @auth
          params[:host] = 'www.googleapis.com'
          params[:expected_response] = Net::HTTPNoContent
          params[:api_key] = Yt.configuration.api_key if Yt.configuration.api_key
          params[:request_tracking_id] = request_tracking_id
        end
      end

      def request_tracking_id
        if instance_variable_defined?(:@parent) && @parent && @parent.respond_to?(:request_tracking_id)
          @parent.request_tracking_id
        elsif instance_variable_defined?(:@auth) && @auth && @auth.respond_to?(:request_tracking_id)
          @auth.request_tracking_id
        end
      end
    end
  end
end
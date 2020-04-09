require 'yt/actions/delete'
require 'yt/actions/update'
require 'yt/actions/patch'

require 'yt/associations/has_attribute'
require 'yt/associations/has_authentication'
require 'yt/associations/has_many'
require 'yt/associations/has_one'
require 'yt/associations/has_reports'

require 'yt/errors/request_error'

module Yt
  module Models
    # @private
    class Base
      include Actions::Delete
      include Actions::Update
      include Actions::Patch

      include Associations::HasAttribute
      extend Associations::HasReports
      extend Associations::HasOne
      extend Associations::HasMany
      extend Associations::HasAuthentication

      # @private
      def initialize(options = {})
        @request_tracking_id = options[:request_tracking_id]
      end

      # The request tracking ID, to support debugging.
      # @return [String] Some arbitrary value supplied by the client.
      attr_reader :request_tracking_id
    end
  end

  # By including Models in the main namespace, models can be initialized with
  # the shorter notation Yt::Video.new, rather than Yt::Models::Video.new.
  include Models
end
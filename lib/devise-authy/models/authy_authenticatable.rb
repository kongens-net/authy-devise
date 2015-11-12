require 'devise-authy/hooks/authy_authenticatable'
module Devise
  module Models
    module AuthyAuthenticatable
      extend ActiveSupport::Concern

      def with_authy_authentication?(request)
        if self.authy_id.present? && self.authy_enabled
          return true
        end

        return false
      end

      module ClassMethods
        def find_by_authy_id(authy_id)
          find(:first, :conditions => {:authy_id => authy_id})
        end

        Devise::Models.config(self, :authy_remember_device, :authy_enable_onetouch, :authy_onetouch_expiration)
      end
    end
  end
end


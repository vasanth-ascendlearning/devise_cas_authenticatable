module DeviseCasAuthenticatable
  module SingleSignOut

    def self.rails3_or_greater?
      defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3
    end

    # Supports destroying sessions by ID for ActiveRecord and Redis session stores
    module DestroySession
      def destroy_session_by_id(env, sid, options = {})
        logger.debug "Single Sign Out from session store: #{current_session_store.class}"

        if session_store_class.name =~ /ActionDispatch::Session::RedisStore/
          session = current_session_store.destroy_session(env, sid, options)
          true
        else
          logger.error "Cannot process logout request because this Rails application's session store is "+
                " #{session_store_class.name} and is not a support session store type for Single Sign-Out."
          false
        end
      end

      def session_store_identifier
        @session_store_identifier ||= DeviseCasAuthenticatable::SessionStoreIdentifier.new
      end

      def current_session_store
        session_store_identifier.current_session_store
      end

      def session_store_class
        session_store_identifier.session_store_class
      end
    end

  end
end

require 'devise_cas_authenticatable/single_sign_out/strategies'
require 'devise_cas_authenticatable/single_sign_out/strategies/base'
require 'devise_cas_authenticatable/single_sign_out/strategies/redis_store'
require 'devise_cas_authenticatable/single_sign_out/rack'

module DeviseCasAuthenticatable
  module SingleSignOut
    module Strategies
      class RedisStore < Base
        include ::DeviseCasAuthenticatable::SingleSignOut::DestroySession

        class << self
          def needs_env?
            false
          end

          def needs_expiry?
            false
          end
        end

        def store_session_id_for_index(env, session_index, session_id, options = {})
          logger.debug("Storing #{session_id} for index #{session_index}")
          current_session_store.set_session(env, cache_key(session_index), session_id, options)
        end

        def find_session_id_by_index(env, session_index)
          sid = current_session_store.get_session(env, cache_key(session_index)).last
          logger.debug("Found session id #{sid} for index #{session_index}") if sid
          sid
        end

        def delete_session_index(env, session_index, options = {})
          logger.debug("Deleting index #{session_index}")
          destroy_session_by_id(env, session_index, options)
        end

        private
        def cache_key(session_index)
          "devise_cas_authenticatable:#{session_index}"
        end
      end
    end
  end
end

::DeviseCasAuthenticatable::SingleSignOut::Strategies.add(:redis_store, DeviseCasAuthenticatable::SingleSignOut::Strategies::RedisStore)

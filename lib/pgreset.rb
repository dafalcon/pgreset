require "pgreset/version"

module ActiveRecord
  module Tasks
    class PostgreSQLDatabaseTasks
      def drop
        # Extract the name of the application database from the configuration and
        # establish a connection to the "postgres" database in the public schema.
        # `configuration_hash` was introduced in rails 6.1.0, prior versions use `configuration`.
        if respond_to?(:configuration_hash, true)
          database_name = configuration_hash.with_indifferent_access.fetch(:database)
          establish_connection(configuration_hash.merge(database: "postgres", schema_search_path: "public"))
        else
          database_name = configuration['database']
          establish_connection(configuration.merge(database: "postgres", schema_search_path: "public"))
        end

        pid_column = 'pid'       # Postgresql 9.2 and newer
        if 0 == connection.select_all("SELECT column_name FROM information_schema.columns WHERE table_name = 'pg_stat_activity' AND column_name = 'pid';").count
          pid_column = 'procpid' # Postgresql 9.1 and older
        end

        connection.select_all "SELECT pg_terminate_backend(pg_stat_activity.#{pid_column}) FROM pg_stat_activity WHERE datname='#{database_name}' AND #{pid_column} <> pg_backend_pid();"
        connection.drop_database database_name
      end
    end
  end
end

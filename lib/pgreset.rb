require "pgreset/version"

module ActiveRecord
  module Tasks
    class PostgreSQLDatabaseTasks
      def drop
        establish_master_connection

        pid_column = 'pid'       # Postgresql 9.2 and newer
        if 0 == connection.select_all("SELECT column_name FROM information_schema.columns WHERE table_name = 'pg_stat_activity' AND column_name = 'pid';").count
          pid_column = 'procpid' # Postgresql 9.1 and older
        end

        connection.select_all "SELECT pg_terminate_backend(pg_stat_activity.#{pid_column}) FROM pg_stat_activity WHERE datname='#{configuration_hash['database']}' AND #{pid_column} <> pg_backend_pid();"
        connection.drop_database configuration_hash['database']
      end
    end
  end
end

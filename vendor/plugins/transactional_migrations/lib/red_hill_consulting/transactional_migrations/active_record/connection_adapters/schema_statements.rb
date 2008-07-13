module RedHillConsulting::TransactionalMigrations::ActiveRecord::ConnectionAdapters
  module SchemaStatements
    def self.included(base)
      base.alias_method_chain :create_table, :transactional_migrations
    end

    def create_table_with_transactional_migrations(name, options = {}, &block)
      if options[:force] == true && !tables.include?(name)
        options = options.dup
        options.delete(:force)
      end
      create_table_without_transactional_migrations(name, options, &block)
    end
  end
end

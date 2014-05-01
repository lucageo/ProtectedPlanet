class OgrPostgres
  def import file: file_path, to: database_name
    @file_path = file
    @database_name = to

    system(ogr_command)
  end

  private

  def ogr_command
    ogr_command_template.squish
  end

  def ogr_command_template
    template_path = File.join(Rails.root, 'lib', 'modules', 'ogr_postgres_command.erb')
    template = File.read(template_path)

    ERB.new(template).result binding
  end

  def db_config
    Rails.configuration.database_configuration[Rails.env]
  end
end

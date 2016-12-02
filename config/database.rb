# ActiveRecord::Base.logger = Logger.new(STDOUT) if Sinatra::Application.development?
Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
  filename = File.basename(model_file).gsub('.rb', '')
  autoload ActiveSupport::Inflector.camelize(filename), model_file
end

env = ENV['DATABASE_URL']
pg = "postgres://localhost/#{APP_NAME}_#{Sinatra::Application.environment}"
db = URI.parse(env || pg)

DB_NAME = db.path[1..-1]

ActiveRecord::Base.establish_connection(
  adapter:  db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  host:     db.host,
  port:     db.port,
  username: db.user,
  password: development? ? 'password' : db.password,
  database: DB_NAME,
  encoding: 'utf8'
)

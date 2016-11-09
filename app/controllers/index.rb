get '/' do
  erb :index
end

get '/admin' do
  @messages = Message.all
  erb :admin
end

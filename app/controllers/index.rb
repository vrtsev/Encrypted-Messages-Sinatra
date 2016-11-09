get '/' do

  erb :index
end

get '/create' do
  erb :create
end

post '/submit' do
  @message = Message.new(params[:message])
  if @message.save
    redirect '/success'
  else
    "Произошла ошибка. Обратитесь к Роману, Вадиму или системному администратору"
  end
end

get '/success' do
  @message = Message.last
  @messages = Message.all
  erb :success
end

get '/secret' do
  redirect '/sessions/new' unless session[:user_id]
  "Secret area!"
end
get '/' do
  erb :index
end

get '/messages/new' do
  @message = Message.new
  erb :'messages/new'
end

post '/messages/create' do
  begin
    params[:message]['content'] = AES.encrypt(params[:message]['content'],
                                              params[:password])
    @message = Message.create(params[:message])
    @safe_link = AES.encrypt(@message.id.to_s, 'encrypt_link')
    @mode = params[:message]['mode']
    @visits = params[:message]['visits']
    @usertime = params[:message]['time']
    erb :'messages/success'
  rescue
    status 500
    erb :'errors/form_error'
  end
end

get '/messages/unlock/*' do
  begin
    @id = AES.decrypt(params['splat'][0], 'encrypt_link')
    @message = Message.find(@id)
    @usertime = @message.time.to_i
    if @message.mode == 'after_visit' && @message.visit_count < @message.visits
      erb :'messages/unlock'
    elsif @message.mode == 'after_time' && Time.new < (@message.created_at + (@usertime * 60))
      erb :'messages/unlock'
    else
      status 204
      erb :'errors/message_deleted'
    end
  rescue
    status 404
    erb :'errors/message_invalid'
  end
end

post '/messages/show/:id' do
  begin
    @message = Message.find(params[:id])
    @content = AES.decrypt(@message.content, params[:password])
    @visit_count = @message.visit_count
    @message.increment!(:visit_count) if @message.mode == 'after_visit'
    erb :'messages/show'
  rescue OpenSSL::Cipher::CipherError
    status 204
    erb :'errors/message_show'
  end
end

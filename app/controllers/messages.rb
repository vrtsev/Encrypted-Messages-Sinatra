require 'aes'

get '/messages/new' do
  @message = Message.new
  erb :'messages/new'
end

post '/messages/create' do
  params[:message]['content'] = AES.encrypt(params[:message]['content'], params[:password])
  @message = Message.create(params[:message])
  @safe_link = AES.encrypt(@message.id.to_s, 'encrypt_link')
  @mode = params[:message]['mode']
  @usertime = params[:message]['time']
  erb :'messages/success'
end

get '/messages/show/:id' do
  @message = Message.find(AES.decrypt(params[:id], 'encrypt_link'))
  @usertime = @message.time.to_i
  if (@message.mode == 'after_visit' && @message.status == 0) || (@message.mode == 'after_time' && Time.new < (@message.created_at + (@usertime*60))) #ВРЕМЯ : 1 МИНУТА
    erb :'messages/unlock'
  else
    erb :'errors/message_deleted'
  end
end

post '/messages/show/:id' do
  begin
    @message = Message.find(AES.decrypt(params[:id], 'encrypt_link'))
    @content = AES.decrypt(@message.content, params[:password])
    if @message.mode == 'after_visit'
      @message.update(status: 1)
    end
    erb :'messages/show'
  rescue OpenSSL::Cipher::CipherError
    erb :'errors/message_show'
  end
end

# get '/messages/clear' do
#   Message.delete_all
#   redirect '/admin'
# end

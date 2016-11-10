require 'aes'
require 'pry'

get '/messages/new' do
  @message = Message.new
  erb :'messages/new'
end

post '/messages/create' do
  params[:message]['content'] = AES.encrypt(params[:message]['content'], params[:password])
  @message = Message.create(params[:message])
  @safe_link = AES.encrypt(@message.id.to_s, 'encrypt_link')
  @mode = params[:message]['mode']
  @visits = params[:message]['visits']
  @usertime = params[:message]['time']
  erb :'messages/success'
end

get '/messages/show/:id' do
  @message = Message.find(AES.decrypt(params[:id], 'encrypt_link'))
  @usertime = @message.time.to_i
  if (@message.mode == 'after_visit' && @message.visit_count < @message.visits) || (@message.mode == 'after_time' && Time.new < (@message.created_at + (@usertime*60))) #ВРЕМЯ : 1 МИНУТА
    binding.pry
    erb :'messages/unlock'
  else
    erb :'errors/message_deleted'
  end
end

post '/messages/show/:id' do
  begin
    @message = Message.find(AES.decrypt(params[:id], 'encrypt_link'))
    @content = AES.decrypt(@message.content, params[:password])
    @visit_count = @message.visit_count
    if @message.mode == 'after_visit'
      @message.increment!(:visit_count)
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

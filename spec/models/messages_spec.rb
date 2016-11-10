require 'spec_helper'

RSpec.describe Message do

  it "encrypt/decrypt content" do
    content = 'This is a message content example'
    password = '123456'
    # enc_content = AES.encrypt(content, password)
    @message = Message.create(content: AES.encrypt(content, password))
    @dec_content = AES.decrypt(@message.content, password)
    expect(@dec_content).to eq('This is a message content example')
  end

  it "encrypt/decrypt id to safe links" do
    @message = Message.create(content: 'example content')
    @enc_id = AES.encrypt(@message.id.to_s, 'encrypt_link')
    @dec_id = AES.decrypt(@enc_id, 'encrypt_link')
    expect(@dec_id.to_i).to eq(@message.id)
  end
end
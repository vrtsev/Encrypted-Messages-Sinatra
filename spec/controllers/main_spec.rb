require 'spec_helper'

RSpec.describe 'MainController', type: :controller do
  it 'loads homepage' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'has view-variable for message form' do
    @message = Message.new
    get '/messages/new'
    expect(last_response).to be_ok
  end

  it 'creates a new message with visit-mode' do
    post 'messages/create', 'message' => { 'content' => 'example', 'mode' => 'after_visit', 'visits' => '4', 'time' => '1'},
                            'password' => '123'
    expect(Message.last.visits).to eq(4)
    expect(last_response).to be_ok
  end

  it 'creates a new message with time-mode' do
    post 'messages/create', 'message' => { 'content' => 'example', 'visits' => '1', 'mode' => 'after_time', 'time' => '4'},
                            'password' => '123'
    expect(Message.last.time).to eq(4)
    expect(last_response).to be_ok
  end
end

RSpec.describe 'MainController show action', type: :controller do
  it 'renders unlock page when visit-mode and correct link' do
    params = { 'content' => 'example', 'mode' => 'after_visit', 'visits' => '4', 'time' => '1'}
    message = Message.create(params)
    safe_link = AES.encrypt(message.id.to_s, 'encrypt_link')
    get "messages/show/#{safe_link}"
    expect(last_response.status).to eq(200)
  end

  it 'renders unlock page when time-mode and correct link' do
    params = { 'content' => 'example', 'mode' => 'after_time', 'visits' => '4', 'time' => '1'}
    message = Message.create(params)
    safe_link = AES.encrypt(message.id.to_s, 'encrypt_link')
    get "messages/show/#{safe_link}"
    expect(last_response.status).to eq(200)
  end

  it 'renders error page when message marked as deleted' do
    params = { 'content' => 'example', 'mode' => 'after_visit', 'visits' => '1', 'time' => '1', 'visit_count' => '2'}
    message = Message.create(params)
    safe_link = AES.encrypt(message.id.to_s, 'encrypt_link')
    2.times { get "messages/show/#{safe_link}" }
    expect(last_response.status).to eq(204)
  end

  it 'renders error page while link is incorrect' do
    get 'messages/show/imzeHdEE1l5T25ExYbbDkg==$yuNmvT5DYN+JIklehzd38w=='
    expect(last_response.status).to eq(404)
  end
end

RSpec.describe 'MainController show action with POST method', type: :controller do
  it 'renders message' do
    encrypted_message = AES.encrypt('example', 'safepassword')
    params = { 'content' => encrypted_message, 'mode' => 'after_visit', 'visits' => '1', 'time' => '1', 'visit_count' => '0'}
    message = Message.create(params)
    post "messages/show/#{message.id}", 'password' => 'safepassword', 'splat' => [], 'captures' => ['472'], 'id' => '472'
    expect(last_response.status).to eq(200)
  end

  it 'renders error page when password is wrong' do
    encrypted_message = AES.encrypt('example', 'okpassword')
    params = { 'content' => encrypted_message, 'mode' => 'after_visit', 'visits' => '1', 'time' => '1', 'visit_count' => '0'}
    message = Message.create(params)
    post "messages/show/#{message.id}", 'password' => 'wrongpassword', 'splat' => [], 'captures' => ['472'], 'id' => '472'
    expect(last_response.status).to eq(204)
  end
end

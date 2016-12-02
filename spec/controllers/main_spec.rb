require 'spec_helper'

describe 'MainController', type: :controller do
  let!(:message) { create :message, content: AES.encrypt('example content', 'safepassword') }
  let(:encrypted_id) { AES.encrypt(message.id.to_s, 'encrypt_link') }
  let(:last_message) { Message.last }

  describe 'index action' do
    it 'renders home page' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  describe 'new action' do
    it 'renders new message page' do
      @message = message
      get '/messages/new'
      expect(last_response).to be_ok
    end
  end

  context 'when user send not-valid form' do
    describe 'create action' do
      it 'renders error page' do
        post 'messages/create', 'message' => { 'content' => ''}
        expect(last_response.status).to eq(500)
      end
    end
  end

  context 'when user creates new message' do
    let(:request) do
      post 'messages/create', 'message' => { 'content' => 'example', 'mode' => 'after_time', 'visits' => '4', 'time' => '1'}, 'password' => '123'
    end

    let(:visit_request) do
      post 'messages/create', 'message' => { 'content' => 'example', 'mode' => 'after_visit', 'visits' => '4', 'time' => '1'}, 'password' => '123'
    end

    describe 'create action' do
      let(:encrypted_id) { AES.encrypt(last_message.id.to_s, 'encrypt_link') }

      it 'saves to database' do
        expect(message.id).to eq(last_message.id)
      end

      it 'renders correct link' do
        request
        get "/messages/unlock/#{encrypted_id}"
        expect(last_response.body).to include('Введите пароль')
      end
    end

    context 'when user choose time-mode' do
      describe 'create action' do
        it 'renders mode value' do
          request
          expect(last_response.body).to include("будет удалено после #{last_message.time} час(ов)")
        end
      end
    end

    context 'when user choose visit-mode' do
      describe 'create action' do
        it 'renders mode value' do
          visit_request
          expect(last_response.body).to include("будет удалено после #{last_message.visits} визитов")
        end
      end
    end

    describe 'create action' do
      it 'encrypts message content' do
        visit_request
        expect(last_message.content).not_to eq('example')
      end
    end
  end

  describe 'unlock action' do
    it 'decrypts message id' do
      get "/messages/unlock/#{encrypted_id}"
      expect(last_response.body).to include("сообщения №#{message.id}")
    end
  end

  context 'when link is incorrect' do
    let(:request) { get "/messages/unlock/something+#{encrypted_id}+something" }

    describe 'show action' do
      it 'returns 404 status code' do
        request
        expect(last_response.status).to eq(404)
      end

      it 'renders error page' do
        request
        expect(last_response.body).to include('Вы ввели неправильную ссылку')
      end
    end
  end

  context 'when link is correct and' do
    let(:request) { get "/messages/unlock/#{encrypted_id}" }

    context 'when message alive' do
      describe 'unlock action' do
        it 'renders unlock page' do
          request
          expect(last_response.body).to include('Введите пароль')
        end
      end
    end

    context 'when message marked as deleted' do
      describe 'unlock action' do
        let(:deleted_message) { create :message, visit_count: 4 }
        let(:encrypted_id) { AES.encrypt(deleted_message.id.to_s, 'encrypt_link') }

        it 'renders message_deleted page' do
          request
          expect(last_response.status).to eq(204)
        end
      end
    end
  end

  context 'when user enter password and' do
    let(:decrypted_id) { AES.decrypt(encrypted_id, 'encrypt_link') }

    context 'when password is correct' do
      let(:password) { 'safepassword' }
      let(:decrypted_content) { AES.decrypt(message.content, password) }
      let(:request) { post "/messages/show/#{decrypted_id}", 'password' => password }

      describe 'show action' do
        it 'renders decrypted message' do
          request
          expect(last_response.body).to include(decrypted_content)
        end

        it 'check that message has 1 visit' do
          expect(last_message.visit_count).to eq(1)
        end

        it 'increments counter' do
          request
          expect(last_message.visit_count).to eq(2)
        end
      end
    end

    context 'when password is incorrect' do
      describe 'unlock page' do
        it 'returns 204 status code' do
          post "/messages/show/#{decrypted_id}", 'password' => 'badpassword'
          expect(last_response.status).to eq(204)
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

describe Api, :aggregate_failures do
  include Rack::Test::Methods

  def app
    Api
  end

  let(:user) { create(:user, password: pwd) }
  let(:pwd) { SecureRandom.uuid }

  describe 'POST /' do
    context 'without token' do
      before { post '/' }

      it { expect(last_response.status).to eq(403) }
    end

    context 'with token' do
      before { post "/", nil, 'Authorization' => "Bearer #{token}" }

      context 'and it is invalid' do
        let(:token) { 'invalid' }

        it { expect(last_response.status).to eq(403) }
      end

      context 'and it is valid' do
        let(:user_session) { create(:user_session) }
        let(:token) { JwtEncoder.encode(uuid: user_session.uuid) }

        it { expect(last_response.status).to eq(201) }
      end
    end
  end

  describe 'POST /login' do
    before { post '/login', params.to_json, 'CONTENT_TYPE' => 'application/json' }

    let(:params) do
      {
        email: email,
        password: password,
      }
    end

    let(:email) { user.email }
    let(:password) { pwd }

    it { expect(last_response.status).to eq 201 }

    context 'with invalid password' do
      let(:password) { SecureRandom.uuid }

      it 'return errors' do
        expect(last_response.status).to eq 401
        expect(JSON.parse(last_response.body)['errors']).to contain_exactly(
          a_hash_including('detail' => I18n.t!('services.user_sessions.create.unauthorized')),
        )
      end
    end
  end

  describe 'POST /signup' do
    before { post '/signup', params.to_json, 'CONTENT_TYPE' => 'application/json' }

    let(:params) do
      {
        name: name,
        email: email,
        password: password,
      }
    end

    let(:name) { 'EmirKusturica' }
    let(:email) { 'emir@kusturica.serb' }
    let(:password) { pwd }

    it { expect(last_response.status).to eq 201 }

    context 'with invalid params' do
      let(:name) { 'Emir%Kusturica' }
      let(:email) { nil }
      let(:password) { nil }

      it 'return errors' do
        expect(last_response.status).to eq 422
        expect(JSON.parse(last_response.body)['errors']).to contain_exactly(
          a_hash_including('detail' => I18n.t!('user.errors.name.invalid')),
          a_hash_including('detail' => I18n.t!('user.errors.email.blank')),
          a_hash_including('detail' => I18n.t!('user.errors.password.blank'))
        )
      end
    end
  end

  describe 'Swagger Documentation' do
    before { get '/swagger/docs' }

    it { expect(last_response.status).to eq 200 }
  end
end
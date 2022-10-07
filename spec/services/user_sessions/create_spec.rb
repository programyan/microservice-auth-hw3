RSpec.describe UserSessions::Create, :aggregate_failures do
  subject(:result) { described_class.call(**params) }

  let(:params) do
    {
      email: email,
      password: password
    }
  end

  let(:user) { create(:user, password: password) }

  let(:email) { user.email }
  let(:password) { SecureRandom.uuid }

  it 'creates a new user_session' do
    expect { result }.to change { UserSession.count }.from(0).to(1)
    expect(result.session).to be_kind_of(UserSession)
  end

  context 'when user does not exist' do
    let(:email) { 'goran@bragovich.serb' }

    it 'does not setup a session' do
      expect { result }.not_to change { UserSession.count }
      expect(result.errors).to eq [I18n.t!('services.user_sessions.create.unauthorized')]
    end
  end

  context 'invalid parameters' do
    let(:email) { nil }

    it 'does not setup a session' do
      expect { result }.not_to change { UserSession.count }
      expect(result.session).to be_blank
    end
  end
end

RSpec.describe Auth::FetchUser, :aggregate_failures do
  subject(:result) { described_class.call(**params) }

  let(:params) do
    {
      uuid: uuid
    }
  end

  let(:user) { create(:user) }
  let(:user_session) { create(:user_session, user: user) }
  let(:uuid) { user_session.uuid }

  it 'returns a user' do
    expect(result.success?).to be true
    expect(result.user).to eq user
  end

  context 'when token is blank' do
    let(:uuid) { nil }

    it 'returns error' do
      expect(result.failure?).to be true
      expect(result.errors).to eq [I18n.t!('services.auth.fetch_user.forbidden')]
    end
  end

  context 'when token is invalid' do
    let(:uuid) { SecureRandom.uuid }

    it 'returns error' do
      expect(result.failure?).to be true
      expect(result.errors).to eq [I18n.t!('services.auth.fetch_user.forbidden')]
    end
  end
end

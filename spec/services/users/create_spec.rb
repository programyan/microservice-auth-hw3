RSpec.describe Users::Create, :aggregate_failures do
  subject(:result) { described_class.call(**params) }

  let(:params) do
    {
      name: name,
      email: email,
      password: password
    }
  end

  let(:name) { 'GoranBregovich' }
  let(:email) { 'goran@bragovich.serb' }
  let(:password) { SecureRandom.uuid }

  it 'creates a new user' do
    expect { result }.to change { User.count }.from(0).to(1)
    expect(result.user).to be_kind_of(User)
  end

  context 'invalid parameters' do
    let(:name) { nil }

    it 'does not create ad' do
      expect { result }.not_to change { User.count }
      expect(result.user).to be_kind_of(User)
    end
  end
end

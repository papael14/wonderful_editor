require "rails_helper"

RSpec.describe User, type: :model do
  subject { user.errors.details[:name][0][:error] }

  context "必要な情報が揃っている場合" do
    let(:user) { build(:user) }
    it "ユーザーが作られる" do
      expect(user).to be_valid
    end
  end

  context "name が空白のとき" do
    let(:user) { build(:user, name: nil) }
    it "エラーとなる" do
      expect(user).to be_invalid
      expect(subject).to eq :blank
    end
  end

  context "name が登録済のとき" do
    let(:user) {build(:user, name: "test")}
    it "エラーとなる" do
      create(:user, name: "test")
      expect(user).to be_invalid
      expect(subject).to eq :taken
    end
  end

  context "email が登録済のとき" do
    let(:user) {build(:user, email: "test@ex.com")}
    it "エラーとなる" do
      create(:user, email: "test@ex.com")
      expect(user).to be_invalid
      expect(user.errors.details[:email][0][:error]).to eq :taken
    end
  end

  context "password が空白のとき" do
    let(:user) {build(:user, password: nil)}
    it "エラーとなる" do
      expect(user).to be_invalid
      expect(user.errors.details[:password][0][:error]).to eq :blank
    end
  end
end

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it 'バリデーションが通る' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it 'ユーザーネームが空欄だとバリデーションに引っかかる' do
      user_without_name = build(:user, name: '')
      expect(user_without_name).to be_invalid
      expect(user_without_name.errors[:name]).to eq ['を入力してください']
    end

    it 'ユーザーネームが使用済みだとバリデーションに引っかかる' do
      user = create(:user)
      user_with_same_name = build(:user, name: user.name)
      expect(user_with_same_name).to be_invalid
      expect(user_with_same_name.errors[:name]).to eq ['はすでに存在します']
    end

    it 'メールアドレスが空欄だとバリデーションに引っかかる' do
      user_without_email = build(:user, email: '')
      expect(user_without_email).to be_invalid
      expect(user_without_email.errors[:email]).to eq ['を入力してください']
    end

    it 'メールアドレスが使用済みだとバリデーションに引っかかる' do
      user = create(:user)
      user_with_same_email = build(:user, email: user.email)
      expect(user_with_same_email).to be_invalid
      expect(user_with_same_email.errors[:email]).to eq ['はすでに存在します']
    end
  end
end

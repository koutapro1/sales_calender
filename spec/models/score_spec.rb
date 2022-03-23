require 'rails_helper'

RSpec.describe Score, type: :model do
  describe 'バリデーション' do
    it 'バリデーションに通る' do
      score = build(:score)
      expect(score).to be_valid
      expect(score.errors).to be_empty
    end

    it '売上が空欄だとバリデーションに引っかかる' do
      score = build(:score, score: "")
      expect(score).to be_invalid
      expect(score.errors[:score]).to eq ["を入力してください", "は数値で入力してください"]
    end

    it '同じユーザーが同じ日付に売上を登録するとバリデーションに引っかかる' do
      score = create(:score)
      score_with_same_start_time_and_user = build(:score, start_time: score.start_time, user_id: score.user_id)
      expect(score_with_same_start_time_and_user).to be_invalid
      expect(score_with_same_start_time_and_user.errors[:start_time]).to eq ["はすでに存在します"]
    end

    it '違うユーザーが同じ日付に売上を登録するとバリデーションに通る' do
      score = create(:score)
      score_with_same_start_time_and_another_user = create(:score, start_time: score.start_time)
      expect(score_with_same_start_time_and_another_user).to be_valid
      expect(score_with_same_start_time_and_another_user.errors[:start_time]).to be_empty
    end
  end
end

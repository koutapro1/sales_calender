require 'rails_helper'

RSpec.describe "Scores", type: :system do
  describe '売上登録' do
    let(:user) { create(:user) }
    before do
      login_as(user)
      visit scores_path
    end

    context 'カレンダー内の売上が登録されていない日付をクリックする', js: true do
      # it '売上登録フォームが表示される' do
      #   page.all('.day')[7].click
      #   byebug
      #   expect(current_path).to eq scores_path
      # end
    end
  end
end

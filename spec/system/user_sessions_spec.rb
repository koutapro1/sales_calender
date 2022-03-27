require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    before { visit login_path }
    context 'フォームに正常値を入力' do
      it 'ログインに成功する' do
        fill_in 'name', with: user.name
        fill_in 'password', with: 'password'
        click_button 'ログイン'
        find('.fa-user-circle').click
        expect(current_path).to eq root_path
        expect(page).to have_content(user.name)
      end
    end

    context 'フォームが未入力' do
      it 'ログインに失敗する' do
        fill_in 'name', with: ""
        fill_in 'password', with: 'password'
        click_button 'ログイン'
        expect(current_path).to eq login_path
        expect(page).to have_content('ログインに失敗しました')
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }
    context 'ログアウトボタンを押す' do
      it 'ログアウトに成功する' do
        visit scores_path
        find('.fa-user-circle').click
        click_link 'ログアウト'
        expect(current_path).to eq login_path
        expect(page).to have_content('ログアウトしました')
      end
    end
  end
end

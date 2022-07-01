require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ログイン前' do
    describe 'ユーザー登録' do
      before { visit new_user_path }

      context 'フォームを正常に入力' do
        it 'ユーザー登録に成功する' do
          fill_in 'user[name]', with: 'test_user'
          fill_in 'user[email]', with: 'email@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '登録する'
          expect(page).to have_content 'ユーザー登録が完了しました'
          expect(User.where(name: 'test_user')).to exist
        end
      end

      context 'フォームに空欄がある' do
        it 'ユーザー登録に失敗する' do
          fill_in 'user[name]', with: ''
          fill_in 'user[email]', with: 'email@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '登録する'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'ユーザーネームを入力してください'
        end
      end

      context 'パスワードとパスワード確認が一致しない' do
        it 'ユーザー登録に失敗する' do
          fill_in 'user[name]', with: 'test_user'
          fill_in 'user[email]', with: 'email@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'passwoad'
          click_button '登録する'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
        end
      end

      context '使用済みのユーザーネームを入力する' do
        it 'ユーザー登録に失敗する' do
          user = create(:user)
          fill_in 'user[name]', with: user.name
          fill_in 'user[email]', with: 'email@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '登録する'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'ユーザーネームはすでに存在します'
        end
      end
    end
  end

  describe 'ログイン後' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    describe 'ユーザー編集' do
      before do
        login_as(user)
        visit edit_user_path(user)
      end

      context 'フォームを正常に入力する' do
        it 'ユーザーネームの変更に成功する' do
          fill_in 'user[name]', with: 'edited_user'
          click_button '変更する'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content 'ユーザー情報を変更しました'
          expect(page).to have_content 'edited_user'
        end
      end

      context '使用済みのユーザーネームを入力する' do
        it 'ユーザーネームの変更に失敗する' do
          fill_in 'user[name]', with: another_user.name
          click_button '変更する'
          expect(page).to have_content 'ユーザーネームはすでに存在します'
        end
      end
    end

    describe 'ページ遷移' do
      before { login_as(user) }

      context '自分のプロフィールページにアクセス' do
        it 'アクセスに成功する' do
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_content user.name
          expect(page).to have_content user.email
        end
      end

      context '他人のプロフィールページにアクセス' do
        it 'アクセスに失敗する' do
          visit user_path(another_user)
          expect(page).to have_content '権限がありません'
          expect(current_path).not_to eq user_path(another_user)
        end
      end

      context '他人のユーザー編集ページにアクセス' do
        it 'アクセスに失敗する' do
          visit edit_user_path(another_user)
          expect(page).to have_content '権限がありません'
          expect(current_path).not_to eq edit_user_path(another_user)
        end
      end
    end
  end
end

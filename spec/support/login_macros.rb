module LoginMacros
  def login_as(user)
    visit login_path
    fill_in 'name', with: user.name
    fill_in 'password', with: 'password'
    click_button 'ログイン'
  end
end
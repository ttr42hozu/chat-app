module SignInSupport
  def sign_in(user)
    visit root_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_on("Log in")
    expect(current_path).to eq root_path
  end
end
# ログインの流れをまとめたもの。ここに記述しておくことでいちいち記述しなくても呼び出すだけで済む（使用するにはspec/rails_helper.rbに設定が必要）
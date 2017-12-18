FactoryBot.define do
  factory :user do
    first "MyString"
    last "MyString"
    email "MyString"
    location "MyString"
    state "MyString"
    password ""
    email_confirmed false
    confirm_token "MyString"
    account_locked false
    login_attempts 1
    last_attempt "2017-12-12 21:24:10"
    unlock_token "MyString"
  end
end

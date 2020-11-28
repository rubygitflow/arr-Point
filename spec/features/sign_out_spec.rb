require 'rails_helper'

feature 'User can log out', %(
  An authenticated user must log out to end the session
) do
  background { visit root_path+'?lang=ru' }

  given(:user) { create(:user, authy_hook_enabled: false) }

  scenario 'Authenticated user logs out' do
    visit new_user_session_path
    login(user)
    visit root_path
    find(".menu-map").click
    find_link('Выйти', visible: :all).click
    expect(page).to have_content 'Учётная запись деактивирована.'
  end
end

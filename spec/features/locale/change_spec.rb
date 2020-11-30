require 'rails_helper'

feature 'User can switch language between RU and EN for any pages' do      
  given(:back_locale) { I18n.locale }

  scenario "user doesn't change a language for the /locales/change path " do
    # https://relishapp.com/rspec/rspec-rails/v/4-0/docs/matchers/redirect-to-matcher
    visit locales_change_path
    expect(page).to have_css('.map')
    expect(I18n.locale.to_s).to_not eq(back_locale)
    end

  scenario 'user changes a language on the root path' do
    visit root_path
    visit locales_change_path
    expect(page).to have_css('.map')
    expect(I18n.locale.to_s).to_not eq(back_locale)
  end

  scenario 'user changes a language on the /users/sign_in path' do
    visit new_user_session_path
    visit locales_change_path
    expect(page).to have_css('form')
    expect(page).to have_css('#new_user')
    expect(I18n.locale.to_s).to_not eq(back_locale)
  end

  scenario 'user switches a language there and back again' do
    visit new_user_session_path+'?lang=ru'
    back_locale = :ru
    click_on 'RU / EN'
    expect(page).to have_css('form')
    expect(page).to have_css('#new_user')
    expect(I18n.locale).to_not eq(back_locale)
    click_on 'EN / RU'
    expect(page).to have_css('form')
    expect(page).to have_css('#new_user')
    expect(I18n.locale).to eq(back_locale)
  end
end

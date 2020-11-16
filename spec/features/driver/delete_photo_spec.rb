require 'rails_helper'

feature "Owner of driver's profile can delete his attached photo" do
  given(:user) { create(:user, :as_driver, :authorized) }
  given(:driver) { create(:driver, user: user) }
  given(:other_driver) { create(:driver) }

  describe 'Authenticated user' do
    background { 
      visit new_user_session_path
      login(user) 
    }

    scenario "deletes photo from driver's profile", js: true do
      driver.photo.attach(create_file_blob)
      visit driver_path(driver)
      # save_and_open_page
      expect(page).to have_css('img')
      accept_confirm do
        click_on 'Удалить фотографию'
      end
      expect(page).to_not have_css('img')
    end

    scenario "tries to delete file from other driver's profile", js: true do
      # periodically we have
      # Capybara::CapybaraError:
      #   Your application server raised an error - It has been raised in your test code because Capybara.raise_server_errors == true

      other_driver.photo.attach(create_file_blob)
      visit driver_path(other_driver)
      # save_and_open_page
      expect(page).to_not have_link 'Удалить фотографию'
    end
  end

  scenario "Unauthenticated user can't delete attached photo", js: true do
    visit driver_path(driver)
    # save_and_open_page
    expect(page).to_not have_link 'Удалить фотографию'
  end
end


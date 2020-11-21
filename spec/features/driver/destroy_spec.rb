require 'rails_helper'

feature "The driver can delete his own profile", %(
  , but he can't delete someone else's profile
) do

  given(:user) { create(:user, :as_driver, :not_an_admin, :authorized) }
  given(:reg_admin) { create(:user, :as_driver, :admin, :authorized) } 

  background do
    visit new_user_session_path
    login(user) 
  end


  scenario "The owner of driver's profile tries to delete it" do
    driver = create(:driver, :with_photo, user: user)
    visit driver_path(driver)

    expect(page).to have_link 'Удалить профиль'
    
    click_on 'Удалить профиль'

    expect(page).to have_content "Профиль водителя был успешно удалён"
  end

  scenario "The admin can't delete driver's profile" do
    driver = create(:driver, :with_photo, user: user)
    logout(user) 

    visit new_user_session_path
    login(reg_admin) 

    visit driver_path(driver)

    expect(page).to_not have_link 'Удалить профиль'
  end
end

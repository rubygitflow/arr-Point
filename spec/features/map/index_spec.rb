require 'rails_helper'

feature 'User can view a map, the service title and the menu', %q(
  To see your location and the nearest taxi 
  on the map and to register in the service via the menu.
) do
  background { visit root_path+'?lang=ru' }

  scenario 'User is viewing a map, the service title and the menu', js: true do
    # save_and_open_page
    expect(page).to have_content '«АВТОМОБИЛЬ НА ХОДУ»'
    expect(page).to have_css('div.menu-map[title="Меню"]')
    expect(page).to have_css('div#map')
    expect(page).to have_css('img.leaflet-tile.leaflet-tile-loaded')
  end

  scenario 'User is clicking on the menu to change the language' do
    find(".menu-map").click
    click_on 'RU / EN'

    expect(page).to have_content '«CAR ON THE MOVE»'
    expect(page).to have_css('div.menu-map[title="Menu"]')
  end

  describe 'Blocked driver' do
    given(:user) { create(:user, :as_driver, :blocked, :authorized) }
    given(:driver) { create(:driver, user: user) }

    background do
      visit new_user_session_path
      login(user) 

      visit driver_path(driver)
      find(".menu-map").click
      click_on 'профиль'
    end

    scenario 'is clicking on the menu to visit his profile' do
      expect(page).to have_content 'Ограниченный доступ'
    end

    scenario 'can open payment details' do
      expect(page).to have_link 'Реквизиты для оплаты'

      click_on 'Реквизиты для оплаты'

      expect(response_headers["Content-Type"]).to eq "application/pdf"
    end
  end

end

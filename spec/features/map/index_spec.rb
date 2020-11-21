require 'rails_helper'

feature 'User can view a map, the service title and the menu', %q(
  To see your location and the nearest taxi 
  on the map and to register in the service via the menu.
) do
  background { visit root_path+'?lang=ru' }

  scenario 'User is viewing a map, the service title and the menu', js: true do
    # save_and_open_page
    expect(page).to have_content '«Точка прибытия»'
    expect(page).to have_css('div.menu-map[title="Меню"]')
    expect(page).to have_css('div#map')
    expect(page).to have_css('img.leaflet-tile.leaflet-tile-loaded')
  end

  scenario 'User is clicking on the menu to change the language' do
    find(".menu-map").click
    click_on 'RU / EN'

    expect(page).to have_content '«arrival Point»'
    expect(page).to have_css('div.menu-map[title="Menu"]')
  end
end

require "spec_helper"

feature "games overview" do
  before :each do
    game = Game.new(name: "Futsal")
    game.save
    visit root_url
    click_link "games"
  end

  scenario "anonymous user visit list of games" do
    expect(page).to have_content("Games")
  end

  scenario "games show up" do
    expect(Game.count).to eq(1)
    expect(page).to have_content("Futsal")
  end
end

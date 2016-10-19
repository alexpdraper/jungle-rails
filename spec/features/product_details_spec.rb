require 'rails_helper'

RSpec.feature "ProductDetails", type: :feature, js: true do

  # SETUP
  before :each do
    @category = Category.create!(name: 'Shirts')

    10.times do |n|
      @category.products.create!(
        name: Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario 'They see all products' do
    # ACT
    visit root_path

    page.first('a.btn.btn-default.pull-right').click

    expect(page).to have_css 'dl.dl-horizontal'

    # DEBUG
    save_screenshot

    # VERIFY
    expect(page.first('dt').text).to have_text 'Name'
  end

end

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    let(:category) { Category.create(name: 'Clothing') }

    context 'when category, name, price, and quantity are present' do
      let(:product) { category.products.create(name: 'Shirt', price: 100_000, quantity: 3) }
      it 'should be valid' do
        expect(product).to be_valid
      end
    end

    context 'when name is not present' do
      let(:product) { category.products.create(price: 100_000, quantity: 3) }
      it 'should have 1 error' do
        expect(product.errors.size).to eq 1
      end

      it 'should have a "Name can\'t be blank" error message' do
        expect(product.errors.full_messages.include?('Name can\'t be blank')).to be true
      end
    end

    context 'when category is not present' do
      let(:product) { Product.create(name: 'Shirt', price: 100_000, quantity: 3) }
      it 'should have 1 error' do
        expect(product.errors.size).to eq 1
      end

      it 'should have a "Category can\'t be blank" error message' do
        expect(product.errors.full_messages.include?('Category can\'t be blank')).to be true
      end
    end

    context 'when price is not present' do
      let(:product) { category.products.create(name: 'Shirt', quantity: 3) }
      it 'should have 1 error' do
        expect(product.errors.size).to eq 3
      end

      it 'should have a "Price can\'t be blank" error message' do
        expect(product.errors.full_messages.include?('Price can\'t be blank')).to be true
      end
    end

    context 'when quantity is not present' do
      let(:product) { category.products.create(name: 'Shirt', price: 100_000) }
      it 'should have 1 error' do
        expect(product.errors.size).to eq 1
      end

      it 'should have a "Quantity can\'t be blank" error message' do
        expect(product.errors.full_messages.include?('Quantity can\'t be blank')).to be true
      end
    end

  end
end

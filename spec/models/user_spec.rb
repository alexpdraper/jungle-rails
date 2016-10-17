require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do

    let(:jim) do
      User.new(first_name: 'Jim',
      last_name: 'Jimmy',
      email: 'jim@example.com',
      password: 'secret',
      password_confirmation: 'secret')
    end

    let(:nancy) do
      User.new(first_name: 'Nancy',
      last_name: 'Nan',
      email: 'nancy@example.com',
      password: 'secret',
      password_confirmation: 'secret')
    end

    context 'when all fields are present' do
      it 'should be valid' do
        jim.save

        expect(jim).to be_valid
      end
    end

    context 'when first_name is not present' do
      it 'should not be valid' do
        jim.first_name = nil
        jim.save

        expect(jim).to_not be_valid
        expect(jim.errors.count).to eq(1)
        expect(jim.errors.full_messages.include?('First name can\'t be blank')).to be true
      end
    end

    context 'when last_name is not present' do
      it 'should not be valid' do
        jim.last_name = nil
        jim.save

        expect(jim).to_not be_valid
        expect(jim.errors.count).to eq(1)
        expect(jim.errors.full_messages.include?('Last name can\'t be blank')).to be true
      end
    end

    context 'when email is not present' do
      it 'should not be valid' do
        jim.email = nil
        jim.save

        expect(jim).to_not be_valid
        expect(jim.errors.count).to eq(1)
        expect(jim.errors.full_messages.include?('Email can\'t be blank')).to be true
      end
    end

    context 'when password and password_confirmation don\'t match' do
      it 'should not be valid' do
        jim.password = 'right'
        jim.password_confirmation = 'notright'
        jim.save

        expect(jim).to_not be_valid
        expect(jim.errors.count).to eq(1)
        expect(jim.errors.full_messages.include?('Password confirmation doesn\'t match Password')).to be true
      end
    end

    context 'when password is not long enough' do
      it 'should not be valid' do
        jim.password = 'a'
        jim.password_confirmation = 'a'
        jim.save

        expect(jim).to_not be_valid
        expect(jim.errors.count).to eq(1)
        puts jim.errors.full_messages
        err_message_re = /^Password is too short/
        expect(jim.errors.full_messages.grep(err_message_re).count).to eq 1
      end
    end

    context 'when the email matches an email already in the database' do
      it 'should not save in the database' do
        jim.email = 'test@example.com'
        nancy.email = 'test@example.com'
        jim.save!
        nancy.save

        expect(nancy).to_not be_persisted

        nancy.email = 'TEST@example.com'
        nancy.save

        expect(nancy).to_not be_persisted
      end
    end

  end
end

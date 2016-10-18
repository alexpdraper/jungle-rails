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
        expect(jim.errors.size).to eq 1
        expect(jim.errors.full_messages.include?('First name can\'t be blank')).to be true
      end
    end

    context 'when last_name is not present' do
      it 'should not be valid' do
        jim.last_name = nil
        jim.save

        expect(jim).to_not be_valid
        expect(jim.errors.size).to eq 1
        expect(jim.errors.full_messages.include?('Last name can\'t be blank')).to be true
      end
    end

    context 'when email is not present' do
      it 'should not be valid' do
        jim.email = nil
        jim.save

        expect(jim).to_not be_valid
        expect(jim.errors.size).to eq 1
        expect(jim.errors.full_messages.include?('Email can\'t be blank')).to be true
      end
    end

    context 'when password and password_confirmation don\'t match' do
      it 'should not be valid' do
        jim.password = 'right'
        jim.password_confirmation = 'notright'
        jim.save

        expect(jim).to_not be_valid
        expect(jim.errors.size).to eq 1
        expect(jim.errors.full_messages.include?('Password confirmation doesn\'t match Password')).to be true
      end
    end

    context 'when password is not long enough' do
      it 'should not be valid' do
        jim.password = 'a'
        jim.password_confirmation = 'a'
        jim.save

        expect(jim).to_not be_valid
        expect(jim.errors.size).to eq 1

        err_message_re = /^Password is too short/
        expect(jim.errors.full_messages.grep(err_message_re).size).to eq 1
      end
    end

    context 'when the email matches an email already in the database' do
      it 'should not save in the database' do
        jim.email = 'test@example.com'
        nancy.email = 'test@example.com'
        jim.save!

        expect { nancy.save! }.to raise_error ActiveRecord::RecordInvalid
        expect(nancy).to_not be_persisted

        nancy.email = 'TEST@example.com'

        expect { nancy.save! }.to raise_error ActiveRecord::RecordInvalid
        expect(nancy).to_not be_persisted
      end
    end

  end

  describe '.authenticate_with_credentials' do

    let(:jim) do
      User.new(first_name: 'Jim',
      last_name: 'Jimmy',
      email: 'jim@example.com',
      password: 'secret',
      password_confirmation: 'secret')
    end

    context 'when the email and password are valid' do
      it 'should return a user' do
        jim.save!

        expect(User.authenticate_with_credentials(jim.email, jim.password)).to eq jim
        expect(User.authenticate_with_credentials(jim.email.downcase, jim.password)).to eq jim
        expect(User.authenticate_with_credentials(jim.email.upcase, jim.password)).to eq jim
        expect(User.authenticate_with_credentials("  #{jim.email}", jim.password)).to eq jim
        expect(User.authenticate_with_credentials(" #{jim.email}   \n  ", jim.password)).to eq jim
      end
    end

    context 'when the password is invalid' do
      it 'should return nil' do
        jim.save!

        expect(User.authenticate_with_credentials(jim.email, "wrong#{jim.password}")).to eq nil
      end
    end

    context 'when the email is not in the database' do
      it 'should return nil' do
        expect(User.authenticate_with_credentials(jim.email, jim.password)).to eq nil
      end
    end

  end
end

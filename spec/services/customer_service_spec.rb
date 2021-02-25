# frozen_string_literal: true

RSpec.describe CustomerService, :vcr do
  let(:first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.last_name }
  let(:email) { "#{Faker::Internet.username}@fake.com" }
  let(:phone_unfiltered) { Faker::PhoneNumber.cell_phone.tr('^0-9', '') }
  let(:phone) do
    phone_unfiltered[0..5] = "678793"
    phone_unfiltered[0..9]
  end
  let(:tags) { "test-tag" }

  subject(:client) { CustomerService.new }

  describe "#create_customer" do
    it "should create shopify customer profile" do
      response = client.create_customer(first_name: first_name, last_name: last_name, email: email, phone: phone, tags: tags)
      expect(response).to be_present
      expect(response).to match(%r{(gid://shopify/Customer/)+([0-9]*)})
    end

    it "should fail to create shopify customer profile because of duplicate email" do
      expect { client.create_customer(first_name: first_name, last_name: last_name, email: email, phone: phone, tags: tags) }.to raise_error(CustomerService::UserCreationError)
    end

    it "should fail to create shopify customer profile because of invalid phone number" do
      expect { client.create_customer(first_name: first_name, last_name: last_name, email: email, phone: "5534", tags: tags) }.to raise_error(CustomerService::UserCreationError)
    end
  end
end

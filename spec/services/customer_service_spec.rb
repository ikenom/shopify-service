
RSpec.describe CustomerService, :vcr do

    let(:first_name) { "John" }
    let(:last_name) { "Smith" }
    let(:email) { "test@gmail.com" }
    let(:phone) { "5123439583" }
    let(:tags) { "test-tag" }

    subject(:client) { CustomerService.new }

    describe "#create_customer" do
      it "should create shopify customer profile" do
        response = client.create_customer(first_name: first_name, last_name: last_name, email: email, phone: phone, tags: tags)
        expect(response).to be_present
        expect(response).to match(/(gid:\/\/shopify\/Customer\/)+([0-9]*)/)
      end

      it "should fail to create shopify customer profile because of duplicate email" do
        client.create_customer(first_name: first_name, last_name: last_name, email: email, phone: phone, tags: tags)
        expect { client.create_customer(first_name: first_name, last_name: last_name, email: email, phone: phone, tags: tags)}.to raise_error(CustomerService::UserCreationError)
      end

      it "should fail to create shopify customer profile because of invalid phone number" do
        expect { client.create_customer(first_name: first_name, last_name: last_name, email: email, phone: "5534", tags: tags)}.to raise_error(CustomerService::UserCreationError)
      end
    end
end
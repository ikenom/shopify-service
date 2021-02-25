# frozen_string_literal: true

RSpec.describe Vendor, type: :model do
  subject { build(:vendor) }

  describe "validations" do
    it { is_expected.to be_mongoid_document }
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:shopify_id) }
    it { is_expected.to validate_presence_of(:collection_id) }
    it { is_expected.to validate_presence_of(:business_name) }
    it { is_expected.to validate_presence_of(:phone) }

    it { is_expected.to have_field(:shopify_id).of_type(String) }
    it { is_expected.to have_field(:collection_id).of_type(String) }
    it { is_expected.to have_field(:business_name).of_type(String) }
    it { is_expected.to have_field(:phone).of_type(String) }

    it { is_expected.to have_index_for(shopify_id: 1) }
  end
end

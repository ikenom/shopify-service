# frozen_string_literal: true

RSpec.describe Vendor, type: :model do
  subject { build(:vendor) }

  describe "validations" do
    it { is_expected.to be_mongoid_document }
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:shopify_id) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:collection_id) }
  end
end

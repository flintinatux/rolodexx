# == Schema Information
#
# Table name: addresses
#
#  id         :string(36)       not null
#  street     :string(255)
#  city       :string(255)
#  state      :string(2)
#  postcode   :string(255)
#  contact_id :string(36)       not null
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Address do
  let(:address) do
    Address.new street: '77 Main St',
                city: 'Washington',
                state: 'DC',
                postcode: '20004'
  end

  subject { address }

  it { should respond_to :street }
  it { should respond_to :city }
  it { should respond_to :state }
  it { should respond_to :postcode }

  it { should respond_to :contact }

  it { should be_valid }

  context "when state is invalid" do
    before { subject.state = 'abc' }
    it { should_not be_valid }
  end
end

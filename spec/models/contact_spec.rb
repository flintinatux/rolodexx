# == Schema Information
#
# Table name: contacts
#
#  id         :string(36)       not null, primary key
#  name       :string(255)
#  sex        :string(255)
#  birthday   :date
#  phone      :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Contact do
  let(:contact) do
    Contact.new name: "Doug Stamper",
                sex: "male",
                birthday: "4/1/1964",
                phone: "555-555-5555",
                email: "thestamper@hotmail.com"
  end

  subject { contact }

  it { should respond_to :name }
  it { should respond_to :sex }
  it { should respond_to :birthday }
  it { should respond_to :phone }
  it { should respond_to :email }

  it { should respond_to :address }
  it { should respond_to :age }

  it { should be_valid }

  context "when the name is blank" do
    before { subject.name = ' ' }
    it { should_not be_valid }
  end

  context "when the sex is not male or female" do
    before { subject.sex = 'dog' }
    it { should_not be_valid }
  end

  context "when the birthday is in the future" do
    before { subject.birthday = 1.day.from_now }
    it { should_not be_valid }
  end

  context "when the email is invalid" do
    before { subject.email = 'clearly not an email' }
    it { should_not be_valid }
  end

  context 'before validation' do
    before { subject.email = ' theStamper @hotMail.com ' }

    it "trims and downcases the email" do
      subject.save
      subject.email.should eq 'thestamper@hotmail.com'
    end
  end

  describe '#age' do
    before { Date.stub today: Date.parse('5/1/2014') }

    it "calculates the age based on birthday" do
      expect(subject.age).to eq 50
    end
  end

  describe '#gravatar_hash' do
    it "creates an MD5 digest of the email" do
      subject.gravatar_hash.should eq 'a8d1d836f9836a376e2b2a92707646a5'
    end
  end
end

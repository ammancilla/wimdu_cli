require "spec_helper"

describe Property do
  let(:property) { Property.new }

  describe "#initialize" do
    it "create a newly Property instance" do
      expect(property.id).not_to be_nil
      expect(property.step).to eq(1)
    end
  end

  describe "#complete?" do
    it "returns true if a property if fully registered" do
      7.times { property.next_step }

      expect(property.complete?).to be_truthy
    end
  end

  describe "#next_step" do
    it "increment by one the current registration step" do
      expect { property.next_step }.to change(property, :step).by(1)
    end
  end

  describe "#valid_attribute?" do
    context "given an invalid title" do
      it "returns false" do
        property.title = ''
        expect(property.valid_attribute?('title')).to be_falsy
      end
    end

    context "given a valid title" do
      it "returns true" do
        property.title = 'Amazing room at Wimdu Office'
        expect(property.valid_attribute?('title')).to be_truthy
      end
    end
  end

  describe "#save" do
    # Already tested by testing the #store method for a Storage instace
  end

  describe "#generate_property_id" do
    it "generate a unique ID for the property" do
      storage = Storage.new
      property.send('generate_property_id')

      expect(storage.find(property.id)).to be_falsy
    end
  end
end
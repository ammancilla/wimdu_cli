require "spec_helper"

describe Storage do
  before :each do
    property = Property.new
    @storage = Storage.new
    @id, @attrs = property.id, property.as_json
  end

  describe "initialize" do
    # Alredy tested by testing #bootstrap method.
  end
  
  describe "#find" do
    it "find a property by ID" do
      @storage.store(@id, @attrs)
      
      expect(@storage.find(@id)).not_to be_nil
    end
  end

  describe "#find_by" do
    it "find all the properties that matched the given attribute and value" do
      @storage.store(@id, @attrs)
      found = @storage.find_by('step' => 1)

      found.each { |_, property| expect(property['step']).to eq(1) }
    end
  end

  describe "#store" do
    it "store the given property in the JSON_FILE" do
      expect { 
        @storage.store(@id, @attrs)
      }.to change{ @storage.properties.count }.by(1)
      expect(@storage.find(@id)).not_to be_nil
    end
  end

  describe "#retrieve_and_parse_data" do
    it "read the stored data from the JSON_FILE and parse it to a Hash" do
      expect(@storage.send('retrieve_and_parse_data').class).to eq(Hash)
    end
  end

  describe "#reset" do
    it "delete all the stored data from the JSON_FILE" do
      current_count = @storage.properties.count

      expect { @storage.reset }.to change{ @storage.properties.count }.by(-current_count)
    end
  end

  describe "#encode_and_store" do
    it "encode to JSON the given data and store it into the JSON_FILE" do
      properties = {}
      10.times do
        property = Property.new
        properties[property.id] = property.as_json
      end

      expect { 
        @storage.send('encode_and_store', properties)
      }.to change{ @storage.properties.count }.by(10)
    end
  end

  describe "#bootstrap" do
    it "create the storage JSON_FILE" do
      FileUtils.rm(Storage::JSON_FILE) if File.exist?(Storage::JSON_FILE)

      expect { 
        @storage.send('bootstrap')
      }.to change{ File.exist?(Storage::JSON_FILE) }.from(false).to(true)
    end
  end
end
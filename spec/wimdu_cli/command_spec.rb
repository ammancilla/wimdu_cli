require "spec_helper"

describe Command do
  let(:exe) { File.expand_path('../../../bin/wimdu_cli', __FILE__) }

  describe "#list" do
    before :each do
      @process = run_interactive("#{exe} list")
    end

    context "with fully registered properties" do
      it "display all the fully registered properties" do
        property = Property.new(
                      title: 'Amazing room at Wimdu Office', 
                      type: 'private room',
                      email: 'foo@example.com',
                      address: 'Voltastr. 5, 13355 Berlin',
                      phone_number: '+1 555 2368',
                      rate_per_night: '12',
                      max_guests: 2,
                      step: 8
                    )
        property.save

        expect(@process.output).to include('Found')
      end
    end

    context "without fully registered properties" do
      it "do not display properties" do
        storage = Storage.new
        storage.reset unless storage.find_by('step' => 8).empty?

        expect(@process.output).to include("No properties found")
      end
    end
  end

  describe "#new" do
    let(:cmd) { "#{exe} new" }

    it "allows for entering data" do
      process = run_interactive(cmd)

      expect(process.output).to include("Starting with new property")
      expect(process.output).to include("Title")
      type "Amazing room at Wimdu Office"
      expect(process.output).to include("Type")
      type "private room"
      expect(process.output).to include("Email")
      type "foo@example.com"
      expect(process.output).to include("Address")
      type "Voltastr. 5, 13355 Berlin"
      expect(process.output).to include("Phone number")
      type "+1 555 2368"
      expect(process.output).to include("Max guests")
      type "2"
      expect(process.output).to include("Nightly rate")
      type "12"
      expect(process.output).to include("Great job!")
    end

    # TODO: Test when the user type invalid data during the registration process
  end

  describe "#continue" do
    context "with the ID of an uncomplete property" do
      it "continue the registration proccess" do
        property = Property.new
        property.save
        process = run_interactive("#{exe} continue #{property.id}")

        expect(process.output).to include("Continuing with #{property.id}")
      end
    end

    context "with an invalid ID" do
      it "display an error message" do
        process = run_interactive("#{exe} continue 1nv4l1d")

        expect(process.output).to include("We couldn't find the property")
      end
    end
  end

  describe "#help" do
    it "display the help text" do
      process = run_interactive("#{exe} help")

      expect(process.output).to include("*** Wimdu CLI help ***")
    end
  end
end
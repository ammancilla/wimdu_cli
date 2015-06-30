# require "spec_helper"

# describe "Wimdu CLI" do
#   let(:exe) { File.expand_path('../../bin/wimdu_cli', __FILE__) }

#   describe "#new" do
#     let(:cmd) { "#{exe} new" }

#     it "allows for entering data" do
#       process = run_interactive(cmd)
#       expect(process.output).to include("Starting with new property")
#       expect(process.output).to include("Title")
#       type "Amazing room at Wimdu Office"
#       expect(process.output).to include("Type")
#       type "private room"
#       expect(process.output).to include("Email")
#       type "foo@example.com"
#       expect(process.output).to include("Address")
#       type "Voltastr. 5, 13355 Berlin"
#       expect(process.output).to include("Phone number")
#       type "+1 555 2368"
#       expect(process.output).to include("Max guests")
#       type "2"
#       expect(process.output).to include("Nightly rate")
#       type "12"
#       expect(process.output).to include("Great job!")
#     end
#   end

#   describe "#help" do
#     let(:cmd) { "#{exe} help" }

#     it "display the help text" do
#       process = run_interactive(cmd)
#       expect(process.output).to include("*** Wimdu CLI help ***")
#     end
#   end
# end

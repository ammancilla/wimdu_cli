$:.unshift File.dirname(__FILE__)

require 'wimdu_cli/storage'
require 'wimdu_cli/property'
require 'wimdu_cli/command'

module WimduCli
  def self.storage
    @storage ||= Storage.new
  end
end
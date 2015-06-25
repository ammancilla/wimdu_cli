require 'yajl'
require 'fileutils'

module WimduCli
  class Storage

    # Public: The path to the JSON file where the data is going to be stored.
    # 
    # Returns the String path to the JSON file
    def json_file
      "#{ENV['HOME']}/.wimdu_storage"
    end

    # Public: initializes a Storage instance and create the JSON file if necessary.
    #
    # Returns the Storage instance.
    def initialize
      bootstrap
    end

    # Public: Look for an specific Property in the JSON file.
    # 
    # id - the String unique identifier for a Property
    # 
    # Returns a Hash with the representation of the Property if found, nil if not.
    def find(id)
      properties[id]
    end

    # Public: Look for all the Properties that matches a specific value for an attribute.
    # 
    # attribute - a Hash containing the name of the attribute to look for and the wanted value
    # 
    # Returns a Hash of Hashes with the representation of all the Properties found.
    def find_by(attribute = {})
      properties.select { |_, attributes| attributes.send('[]', attribute.keys[0]) == attribute.values[0] }
    end

    # Public: writes to the JSON file the information of a Property.
    # 
    # id - the String unique identifier for a property
    # attributes - a Hash containing the representation of a Property object
    # 
    # Returns nothing.
    def store(id, attributes)
      data = retrieve_and_parse_data
      data[id] = attributes
      encode_and_store(data)
    end

    # Public: Clear all the stored data from the JSON file
    # 
    # Returns nothing.
    def reset
      File.open(json_file, 'w') { |f| f.write('{}') }
    end

    # Public: read the data stored in the JSON file and parse it
    #  
    # Returns a Hash of Hashes with the representation of each stored Property.
    def retrieve_and_parse_data
      data = File.open(json_file, 'r')
      Yajl::Parser.parse data
    end
    alias_method :properties, :retrieve_and_parse_data

    private
      # Private: encode and write the JSON file the given properties
      # 
      # data - Hash of Hashes with the properties to write to the JSON file
      # 
      # Returns nothing.
      def encode_and_store(data)
        encoded = Yajl::Encoder.encode(data, pretty: true)
        File.open(json_file, 'w') { |f| f.write(encoded) }
      end

      # Private: create the JSON file if it haven't been created
      #  
      # Returns nothing.
      def bootstrap
        unless File.exist?(json_file)
          FileUtils.touch(json_file) 
          File.open(json_file, 'w') { |f| f.write('{}') }
        end
      end
  end
end
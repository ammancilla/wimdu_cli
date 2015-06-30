module WimduCli  
  class Command
    class << self

      # Public: display all the fully registered Properties
      #
      # Returns nothing
      def list
        properties = WimduCli.storage.find_by('step' => 8)
        if properties.empty?
          p "No properties found."
        else
          p "Found #{properties.count} offer(s)"

          properties.each { |id, attributes| p "#{id}: #{attributes['title']}" }
          p ""
        end
      end

      # Public: display the form to create a new Property
      #
      # Returns nothing
      def new
        property = Property.new
        property.save
        p "Starting with new property #{property.id}"
        create_or_continue_property(property)
      end

      # Public: display the form to continue creating a partially created Property
      #
      # id - the String unique identifier of the Property
      # 
      # Returns nothing
      def continue(id)
        if property_attributes = WimduCli.storage.find(id)
          property = Property.new(property_attributes.merge(id: id))
          if property.complete?
            p "Listing #{property.id} is already complete!"
          else
            p "Continuing with #{id}"
            create_or_continue_property(property)
          end
        else
          p "We couldn't find the property #{id}. Try again or create a new one\n\n"
        end
      end

      # Public: clear the JSON file used to store the data
      # 
      # Returns nothing
      def reset
        WimduCli.storage.reset
        p "Done! All the previous registered information is gone."
      end

      def help
        text = [
          "*** Wimdu CLI help ***",
          "wimdu_cli                           alias of help command",
          "wimdu_cli list                      show the list of fully registered properties",
          "wimdu_cli new                       create a new property",
          "wimdu_cli continue <property_id>    continue with the creation of a partially created property",
          "wimdu_cli reset                     clear the Wimdu storage",
          "wimdu_cli help                      display list of available commands"
        ].join("\n")
        p text
      end

      private
        # Private: manage the creation process of a Property
        #
        # property - an instance of the Property class
        # 
        # Returns nothing
        def create_or_continue_property(property)
          while !property.complete?  
            case property.step
            when 1
              read_property_attr property, 'title', 'Title'
            when 2
              read_property_attr property, 'type', 'Type'
            when 3
              read_property_attr property, 'email', 'Email'
            when 4
              read_property_attr property, 'address', 'Address'
            when 5
              read_property_attr property, 'phone_number', 'Phone number'
            when 6
              read_property_attr property, 'max_guests', 'Max guests'
            when 7
              read_property_attr property, 'rate_per_night', 'Nightly rate in EUR'
            end
          end
          p "Great job! Listing #{property.id} is complete!"
        end

        # Private: ask, read and assign a value for the specified attribute
        # 
        # property - an instance of the Property class
        # attribute - the name of the attribute to read
        # label - the text to display to ask for the attribute
        # 
        # Returns nothing
        def read_property_attr(property, attribute, label)
          begin
            p "#{label}: "
            property.send("#{attribute}=", $stdin.gets.chomp)
            p "Error: #{property.errors[attribute].join(', ')}" unless property.valid_attribute?(attribute)
          end while(!property.valid_attribute?(attribute))
          property.next_step
          property.save
        end
    end
  end
end
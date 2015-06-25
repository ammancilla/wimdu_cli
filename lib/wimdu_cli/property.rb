require 'active_model'

module WimduCli
  class Property
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    attr_accessor :id, :title, :type, :email, :address, :phone_number, :rate_per_night, :max_guests, :step

    # Public: Create a new Property object and generate a unique identifier.
    # 
    # Returns the newly initialized Property
    def initialize(attributes = {})
      super
      generate_property_id unless @id
      @step ||= 1
    end

    # Validations
    validates :title, :type, :email, :address, :phone_number, :rate_per_night, :max_guests, presence: true
    validates :type, inclusion: { in: ['holiday home', 'apartment', 'private room'] }
    validates :email, format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\z/ }
    validates :phone_number, format: { with: /\A\+?\d{1,2}\s+\d{3}\s+\d{4}\z/ }
    validates :rate_per_night, numericality: { greater_than: 0 }
    validates :max_guests, numericality: { only_integer: true, greater_than: 0 }

    # Public: tests whether a Property if FULLY registered.
    # 
    # Returns true if FULLY registered, false if not.
    def complete?
      @step == 8
    end

    # Public: increase the current registration step for a Property
    # 
    # Returns nothing.
    def next_step
      @step += 1
    end

    # Public: check whether an attribute is valid.
    # 
    # attribute - the name of the attribute to validate
    # 
    # Returns true if the attribute is valid, false if not.
    def valid_attribute?(attribute)
      self.validate
      self.errors[attribute].empty?
    end

    # Public: store to the JSON file the information of the Property.
    # 
    # attribute - the name of the attribute to validate
    # 
    # Returns true if the attribute is valid, false if not.
    def save
      WimduCli.storage.store(self.id, self.as_json)
    end

    # Public: define the list of attributes to be parsed as JSON
    # 
    # Returns a Hash with all the attributes to be parsed
    def attributes
      { 
        title: nil, type: nil, email: nil, 
        address: nil, phone_number: nil, 
        rate_per_night: nil, max_guests: nil, 
        step: nil  
      }
    end

    private
      # Private: generate an unique identifier for a Property
      # 
      # Returns nothing.
      def generate_property_id
        begin
          @id = SecureRandom.hex(4)
        end while(WimduCli.storage.find(@id))
      end
  end
end
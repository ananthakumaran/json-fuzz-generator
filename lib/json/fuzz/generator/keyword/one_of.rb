module JSON
  module Fuzz
    module Generator
      class Keyword
        class OneOf 
          class << self
            def invalid_params(attributes)
              one_of = attributes["oneOf"]
              raise "No oneOf keyword given: #{attributes}" unless one_of

              generated_params = []

              one_of.each do |schema|
                temp_params = JSON::Fuzz::Generator.generate(schema).reject do |param|
                  ::JSON::Validator.validate(attributes, param, parse_data: false)
                end
                temp_params.each {|e| generated_params << e}
              end

              raise "failed to generate invalid_params for schema: #{attributes}" if generated_params.empty?
              generated_params.uniq
            end

            def valid_param(attributes)
              one_of = attributes["oneOf"]
              raise "No oneOf keyword given: #{attributes}" unless one_of

              generated_params = []

              one_of.each do |schema|
                temp_params = JSON::Fuzz::Generator.generate(schema).select do |param|
                  ::JSON::Validator.validate(attributes, param, parse_data: false)
                end
                temp_params.each {|e| generated_params << e}
              end

              raise "failed to generate invalid_params for schema: #{attributes}" if generated_params.empty?
              generated_params.uniq.sample
            end
          end
        end
      end
    end
  end
end

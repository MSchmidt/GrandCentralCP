require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  should "save a new domain" do
    Domain.make
    assert_equal 1, Domain.count
  end
  
  context "A Domain instance" do
    setup do
      10.times { Domain.make }
    end
    
    should_validate_presence_of :fqdn
    should_validate_uniqueness_of :fqdn
    should_ensure_length_at_least :fqdn, 4
  end
end

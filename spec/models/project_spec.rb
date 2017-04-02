require 'rails_helper'

RSpec.describe Project, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe ".validate_title" do

    it "is invalid without title" do
      project = Project.new( :description => "no title test")
      expect(project).to_not be_valid
    end
    
  end

end

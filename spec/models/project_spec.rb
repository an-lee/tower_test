require 'rails_helper'

RSpec.describe Project, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe ".validate_title" do

    before do
      @user = User.create( :email => "test@example.com", :password => "111111")
    end

    it "is invalid without title" do
      project = Project.new( :description => "no title test",
                             :user => @user)
      expect(project).to_not be_valid
    end

    it "is valid with title" do
      project = Project.new( :title => "title", :description => "with title test",
                             :user => @user)
      expect(project).to be_valid
    end

  end

end

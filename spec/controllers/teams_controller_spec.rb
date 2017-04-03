require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  describe ".accesse to team" do

    before do
      @user = User.create( :email => "test1@example.com", :password => "111111", :name => "Mike")
    end

    it "shold get show" do
      sign_in(@user)
      team = Team.create(:title => "team1")
      get :index
      expect(assigns(:teams)).to eq([team])
    end

  end
end

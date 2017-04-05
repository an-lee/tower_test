require 'rails_helper'

RSpec.describe Team, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { is_expected.to validate_presence_of(:title)}
  it { is_expected.to belong_to(:user)}
end

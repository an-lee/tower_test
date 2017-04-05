require 'rails_helper'

RSpec.describe Message, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { is_expected.to validate_presence_of(:content)}
  it { is_expected.to belong_to(:user)}
  it { is_expected.to belong_to(:todo)}
  it { is_expected.to belong_to(:project)}
end

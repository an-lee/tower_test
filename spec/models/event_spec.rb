require 'rails_helper'

RSpec.describe Event, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { is_expected.to validate_presence_of(:action)}
  it { is_expected.to belong_to(:user)}
  it { is_expected.to belong_to(:todo)}
  it { is_expected.to belong_to(:project)}
  it { is_expected.to belong_to(:team)}

end

require 'rails_helper'

RSpec.describe Project, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { is_expected.to validate_presence_of(:title)}
  it { is_expected.to belong_to(:user)}
  it { is_expected.to belong_to(:team)}
  it { is_expected.to have_many(:todos)}
  it { is_expected.to have_many(:events)}
  it { is_expected.to have_many(:accesses)}
  it { is_expected.to have_many(:members)}
  it { is_expected.to have_many(:messages)}
end

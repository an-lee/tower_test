require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { is_expected.to have_many(:teams)}
  it { is_expected.to have_many(:projects)}
  it { is_expected.to have_many(:todos)}
  it { is_expected.to have_many(:messages)}
end

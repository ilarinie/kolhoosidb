require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'to_json does not return error' do
    it 'should be fine' do
      @user = create(:user)
      @user.to_json
    end
  end
end

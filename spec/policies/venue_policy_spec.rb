require 'rails_helper'
require 'policies/shared_examples/event_manager_only'

RSpec.describe VenuePolicy, type: :policy do
  describe 'create?' do
    it_behaves_like 'it requires user to be in EventManagers group', :create?
  end

  describe 'update?' do
    it_behaves_like 'it requires user to be in EventManagers group', :update?
  end
end

require 'next_in_place/view_helpers'

module NextInPlace
  class Railtie < Rails::Railtie
    initializer 'next_in_place.view_helpers' do
      ActiveSupport.on_load(:action_view) { include NextInPlace::ViewHelpers }
    end
  end
end

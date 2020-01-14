class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  default_scope { where(deleted_at: nil) }
end

class CachedToken < ApplicationRecord
  enum service: [:github]
end

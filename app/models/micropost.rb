class Micropost < ApplicationRecord
  belongs_to :member
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :member_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end

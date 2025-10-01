class Quote < ApplicationRecord
  belongs_to :author, class_name: "Member", foreign_key: "author_id"
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :author_id, presence: true
  validates :content, presence: true, length: { maximum: 280 }
end

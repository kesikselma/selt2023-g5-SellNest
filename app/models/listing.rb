class Listing < ActiveRecord::Base


  has_many :listing_tags
  has_many :tags, through: :listing_tags
  # belongs_to :user
  has_many_attached :photos

  scope :search_by_title, -> (query) { where('name LIKE ?', "%#{query}%")}

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

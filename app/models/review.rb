class Review < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  class << self
    def search query
      __elasticsearch__.search(
        {
          query: {
            multi_match: {
              query: query,
              fields: ['name', 'content', 'date']
            }
          },
          highlight: {
            pre_tags: ['<span class="highlight">'],
            post_tags: ['</span>'],
            fields: {
              name: {},
              content: {},
              date: {}
            }
          }
        }
      )
    end
  end

  belongs_to :user
  belongs_to :tour
  has_many :comments

  enum status: {waiting: 0, rejected: 1, view: 2}

  scope :sort_by_created_at, -> {order created_at: :desc}
  scope :sort_by_status, -> {order :status}
  
end

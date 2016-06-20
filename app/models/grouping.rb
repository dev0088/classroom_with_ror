# frozen_string_literal: true
class Grouping < ActiveRecord::Base
  include Sluggable

  update_index('stafftools#grouping') { self }

  has_many :groups, dependent: :destroy
  has_many :users, through: :groups, source: :repo_accesses

  belongs_to :organization

  validates :organization, presence: true

  validates :title, presence: true
  validates :title, uniqueness: { scope: :organization }

  validates :slug, uniqueness: { scope: :organization_id }
end

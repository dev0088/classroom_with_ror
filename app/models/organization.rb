# frozen_string_literal: true

class Organization < ApplicationRecord
  include Flippable
  include Sluggable

  update_index("stafftools#organization") { self }

  default_scope { where(deleted_at: nil) }

  has_many :assignments,              dependent: :destroy
  has_many :groupings,                dependent: :destroy
  has_many :group_assignments,        dependent: :destroy
  has_many :repo_accesses,            dependent: :destroy

  belongs_to :roster, optional: true

  has_and_belongs_to_many :users

  validates :github_id, presence: true

  validates :title, presence: true
  validates :title, length: { maximum: 60 }
  validates :title, uniqueness: { scope: :github_id }

  validates :slug, uniqueness: true

  validates :webhook_id, presence: true

  before_destroy :silently_remove_organization_webhook

  def all_assignments(with_invitations: false)
    return assignments + group_assignments unless with_invitations

    assignments.includes(:assignment_invitation) + \
      group_assignments.includes(:group_assignment_invitation)
  end

  def github_client
    if Rails.env.test?
      token = users.first.token unless users.first.nil?
    else
      token = users.limit(1).order("RANDOM()").pluck(:token)[0]
    end
    Octokit::Client.new(access_token: token)
  end

  def github_organization
    @github_organization ||= GitHubOrganization.new(github_client, github_id)
  end

  def name_for_slug
    "#{github_id} #{title}"
  end

  def one_owner_remains?
    users.count == 1
  end

  def last_classroom_on_org?
    return Organization.where(github_id: github_id).length <= 1
  end

  def silently_remove_organization_webhook
    return true unless last_classroom_on_org?

    begin
      github_organization.remove_organization_webhook(webhook_id)
    rescue GitHub::Error => err
      logger.info err.message
    end

    true
  end
end

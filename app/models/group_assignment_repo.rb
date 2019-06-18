# frozen_string_literal: true

class GroupAssignmentRepo < ApplicationRecord
  include GitHubRepoable
  include AssignmentRepoable

  update_index("group_assignment_repo#group_assignment_repo") { self }

  enum configuration_state: %i[not_configured configuring configured]

  belongs_to :group
  belongs_to :group_assignment
  alias assignment group_assignment

  has_one :organization, -> { unscope(where: :deleted_at) }, through: :group_assignment

  has_many :repo_accesses, through: :group

  validates :group_assignment, presence: true

  validates :group, presence: true
  validates :group, uniqueness: { scope: :group_assignment }

  before_destroy :silently_destroy_github_repository

  delegate :creator, :starter_code_repo_id, to: :group_assignment
  delegate :github_team_id,                 to: :group
  delegate :default_branch, :commits,       to: :github_repository

  def github_team
    @github_team ||= group.github_team
  end

  private

  delegate :slug, to: :group_assignment
end

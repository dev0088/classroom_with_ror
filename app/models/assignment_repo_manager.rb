class AssignmentRepoManager
  def initialize(assignment, repo_access)
    @assignment         = assignment
    @organization       = assignment.organization
    @organization_owner = @organization.fetch_owner
    @repo_access        = repo_access
  end

  # Public
  #
  def find_or_create_assignment_repo(assignment_title)
    find_assignment_repo || create_assignment_repo(assignment_title)
  end

  # Internal
  #
  def find_assignment_repo
    @assignment.assignment_repos.find_by(repo_access: @repo_access)
  end

  # Internal
  #
  def create_assignment_repo(assignment_title)
    github_repository = GitHubRepository.new(@organization_owner.github_client)
    repo              = github_repository.create_repository(assignment_title,
                                                            organization: @organization.github_id,
                                                            team_id:      @repo_access.github_team_id,
                                                            private:      @assignment.private?)

    assignment_repo = AssignmentRepo.new(assignment: @assignment, github_repo_id: repo.id, repo_access: @repo_access)
    assignment_repo.save!

    assignment_repo
  end
end

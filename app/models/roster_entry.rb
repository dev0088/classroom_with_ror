# frozen_string_literal: true

class RosterEntry < ApplicationRecord
  belongs_to :roster
  belongs_to :user, optional: true

  validates :identifier, presence: true
  validates :roster,     presence: true

  def self.to_csv
    roster_array = []
    CSV.generate(headers: true, col_sep: ",", force_quotes: true) do |csv|
      csv << %i[identifier github_username name]

      all.sort_by(&:identifier).each do |entry|
        name  = ""
        login = entry.user ? entry.user.github_user.login : ""
        name  = entry.user.github_user.name ? entry.user.github_user.name : "" if entry.user

        roster_array << [entry.identifier, login, name]
      end
      roster_array.map { |e| csv << e }
    end
  end
end

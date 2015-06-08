class CreateGroupsAndGroupings < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :github_team_id, null: false
    end

    add_index :groups, :github_team_id, unique: true

    create_table :groupings do |t|
      t.string     :title,        null: false
      t.belongs_to :organization, index: true
    end

    change_table :groups do |t|
      t.belongs_to :grouping, index: true
    end
  end
end

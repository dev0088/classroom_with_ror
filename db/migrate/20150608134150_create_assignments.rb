class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string     :title,        null: false
      t.belongs_to :organization, index: true

      t.timestamps null: false
    end

    create_table :group_assignments do |t|
      t.string     :title,        null: false
      t.belongs_to :organization, index: true

      t.timestamps null: false
    end

    change_table :assignment_repos do |t|
      t.belongs_to :assignment, index: true
    end

    change_table :group_assignment_repos do |t|
      t.belongs_to :group_assignment, index: true
    end
  end
end

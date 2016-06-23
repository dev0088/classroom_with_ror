class AddNullRestrictionForGroupingAndGroupSlug < ActiveRecord::Migration
  def up
    change_column :groupings, :slug, :string, null: false
    change_column :groups,    :slug, :string, null: false
  end

  def down
    change_column :groupings, :slug, :string, null: true
    change_column :groups,    :slug, :string, null: true
  end
end

class CreateJoinTableExpertCategory < ActiveRecord::Migration[7.2]
  def change
    create_join_table :experts, :categories do |t|
      # t.index [:expert_id, :category_id]
      # t.index [:category_id, :expert_id]
    end
  end
end

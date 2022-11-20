class VoteTableAdd2 < ActiveRecord::Migration[4.2]
  
  def self.up
    add_column :rqre_votes, :questionnaire_id, :integer, after: :id
  end

  def self.down
    remove_column :rqre_votes, :questionnaire_id
  end
end

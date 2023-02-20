class QuestionTableDtype < ActiveRecord::Migration[4.2]
  
  def self.up
    change_column :rqre_questions, :dtype, :string
  end

  def self.down
    change_column :rqre_questions, :dtype, :integer
  end
end

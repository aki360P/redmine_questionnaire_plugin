class ChangeQuestionnaireLongtext < ActiveRecord::Migration[4.2]

  def self.up
    change_column :rqre_questionnaires, :note, :longtext
    change_column :rqre_questionnaires, :description, :longtext
  end

  def self.down
    change_column :rqre_questionnaires, :note, :string
    change_column :rqre_questionnaires, :description, :string
  end

end

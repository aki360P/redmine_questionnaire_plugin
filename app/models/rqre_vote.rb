class RqreVote < ActiveRecord::Base
  include Redmine::SafeAttributes
  belongs_to :rqre_question, dependent: :destroy

  #def self.find_by_id(questionnaire_id)
  #  #rqre_questionnaire = RqreQuestionnaire.where(['id = ?', questionnaire_id]).first
  #  rqre_questionnaire = RqreQuestionnaire.where(['id = ?', questionnaire_id]).first
  #  rqre_questionnaire
  #end

end

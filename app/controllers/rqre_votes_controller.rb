class RqreVotesController < ApplicationController
  unloadable
  before_action :require_login
  before_action :find_user
  #before_action :find_project, :except => [:show, :edit, :update, :destroy]
  #before_action :find_rqre_question
  #before_action :authorize

  def index
    rqre_questionnaire_id = params[:id]
    @rqre_questions = RqreQuestion.where(rqre_questionnaire_id: rqre_questionnaire_id)
    @rqre_votes = RqreVote.where(rqre_question_id: @rqre_questions.ids, user_id: @user.id)

    puts '-----------------rqre_vote_3'
  end

  def vote
    rqre_question_id = params[:id]
    #rqre_question_id = params[:rqre_vote][:rqre_question_id]
    rqre_question = RqreQuestion.find(rqre_question_id)
    rqre_vote = RqreVote.where(rqre_question_id: rqre_question_id, user_id: @user.id).first

    #save vote
    if rqre_vote.nil?
      #new
      rqre_vote = RqreVote.new
      rqre_vote['rqre_questionnaire_id'] = rqre_question[:rqre_questionnaire_id]
      rqre_vote['rqre_question_id'] = rqre_question_id
      rqre_vote['user_id'] = @user.id
      rqre_vote['answer'] = params[:answer]
      rqre_vote.save!
      puts '-----------------rqre_vote_1'
    else
      #update 
      rqre_vote['answer'] = params[:answer]
      rqre_vote['freezed'] = '0'
      rqre_vote.save!
      puts '-----------------rqre_vote_2'
    end
  end

  def vote_freeze

    rqre_questionnaire_id = params[:id]
  
    #fix each votes of a user
    rqre_questions = RqreQuestion.where(rqre_questionnaire_id: rqre_questionnaire_id)
    rqre_votes = RqreVote.where(rqre_question_id: rqre_questions.ids, user_id: @user.id)

    rqre_votes.update(freezed:'1')

    
    #fix questionnaire of a user
    rqre_vote = RqreVote.where(rqre_questionnaire_id: rqre_questionnaire_id, rqre_question_id: '0', user_id: @user.id).first
    #save
    if rqre_vote.nil?
      #new
      rqre_vote = RqreVote.new
      rqre_vote['rqre_questionnaire_id'] = rqre_questionnaire_id
      rqre_vote['rqre_question_id'] = '0'   # 0 represents that it is a qustionnaire summary record of a user
      rqre_vote['user_id'] = @user.id
      rqre_vote['freezed'] = '1'
      rqre_vote.save!
      puts '-----------------rqre_vote_1'
    else
      #update 
      rqre_vote.update(freezed:'1')
      puts '-----------------rqre_vote_2'
    end

    redirect_to project_rqre_questionnaires_path('1')
  end
  private

  def find_user
    @user = User.current
  end

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def rqre_vote_params
    params.require(:rqre_vote).permit(:rqre_question_id,:user_id,:answer)
  end
end

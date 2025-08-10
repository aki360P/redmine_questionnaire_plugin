class RqreVotesController < ApplicationController
  #unloadable
  before_action :require_login
  before_action :find_user
  #before_action :find_project, :except => [:show, :edit, :update, :destroy]
  #before_action :find_rqre_question
  #before_action :authorize


  def vote
    @rqre_index = params[:rqre_index].to_i
    
    puts '======'

    id = params[:id]
    @rqre_questionnaire = RqreQuestionnaire.find(id)
    @rqre_questions = RqreQuestion.where("rqre_questionnaire_id = ?", id).order(title: :asc)
    @rqre_question = @rqre_questions[@rqre_index]

    @rqre_vote = RqreVote.where(rqre_questionnaire_id: id, rqre_question_id: @rqre_question.id, user_id: @user.id).first

    
    unless params[:rqre_votes].nil?
      rqre_vote = RqreVote.create(rqre_questionnaire_params)
      rqre_vote.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_rqre_questionnaire_path(@project, rqre_questionnaire.id)
    end


    if @rqre_vote.nil?
      #new
      @rqre_vote = RqreVote.new
      #render partial: 'rqre_votes/vote'

    #else
    #  #update 
    #  rqre_vote['answer'] = params[:answer]
    #  rqre_vote['freezed'] = '0'
    #  rqre_vote.save!
    end
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

class RqreQuestionnairesController < ApplicationController
  unloadable
  before_action :require_login
  before_action :find_user, :find_project
  #before_action :authorize

  def initialize
    super()
  end

  def index
    # find questionnaires
    @rqre_questionnaires = RqreQuestionnaire.where("project_id = ?", @project.id)

    # find number of votes
    @rqre_votes = RqreVote.where(rqre_questionnaire_id: @rqre_questionnaires.ids, rqre_question_id: '0', freezed: '1')

    puts @rqre_questionnaires.length
    puts '--------'

  end
  
  def show
    #show a questionnaire
    id = params[:id]
    @rqre_questionnaire = RqreQuestionnaire.find(id)

    #show questions
    #sort with question title (title may begin with sort key)
    @rqre_questions = RqreQuestion.where("rqre_questionnaire_id = ?", id).order(title: :asc)

    #find existing answer
    @rqre_votes = RqreVote.where(rqre_questionnaire_id: id, user_id: @user.id).pluck(:rqre_question_id, :answer)
    #@rqre_votes_q = @rqre_votes["rqre_question_id"]
    #@rqre_votes_a = @rqre_votes["answer"]
  end

  def result
    id = params[:id]
    @rqre_questionnaire = RqreQuestionnaire.find(id)
    @rqre_questions = RqreQuestion.where("rqre_questionnaire_id = ?", id).order(title: :asc)
    @rqre_votes = RqreVote.where(rqre_questionnaire_id: id, freezed: '1')

    @rqre_data = {}
    @rqre_votes.each do |v|
      if @rqre_data[v.rqre_question_id].nil?
        @rqre_data[v.rqre_question_id] =[]
      end 
      @rqre_data[v.rqre_question_id] = @rqre_data[v.rqre_question_id].push(v.answer)
    end

    #gon.rqre_votes = @rqre_votes

    #gon.rqre_votes = {}
    #@rqre_votes.each do |v|
    #  if gon.rqre_votes[v.question_id].nil?
    #    gon.rqre_votes[v.question_id] =[]
    #  end 
    #  gon.rqre_votes[v.question_id] = gon.rqre_votes[v.question_id].push(v.answer)
    #end

    puts '----rqre2'
  end


  def edit
    @rqre_questionnaire = RqreQuestionnaire.find(params[:id])
    @rqre_questions = RqreQuestion.where("questionnaire_id = ?", params[:id])
    puts '----rqre2'
  end

  def new
    @rqre_questionnaire = RqreQuestionnaire.new
    @rqre_questionnaire['end'] = Date.today
    @rqre_questionnaire['project_id'] = @project.id
  end

  def create
    unless params[:rqre_questionnaires].nil?
      rqre_questionnaire = RqreQuestionnaire.create(rqre_questionnaire_params)
      rqre_questionnaire.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_rqre_questionnaire_path(@project, rqre_questionnaire.id)
    end
  end

  def update
    unless params[:rqre_questionnaires].nil?
      rqre_questionnaire = RqreQuestionnaire.find(params[:id])
      
      rqre_questionnaire.update(rqre_questionnaire_params)
      rqre_questionnaire.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_rqre_questionnaire_path(@project, params[:id])
    end
  end
  
  def vote
    id = params[:id]
    #@rqre_questionnaire = RqreQuestionnaire.find(id)
    #@rqre_questions = RqreQuestion.where("rqre_questionnaire_id = ?", id).order(title: :asc)

    rqre_vote = RqreVote.where(rqre_question_id: params[:rqre_question_id], user_id: @user.id).first
    

    #rqre_vote = RqreVote.new(rqre_vote_params)
    #rqre_vote['user_id'] = @user.id
    #rqre_vote['freezed'] = '0'
    #rqre_vote.save!

    #save vote
    if rqre_vote.nil?
      #new
      rqre_vote = RqreVote.new
      rqre_vote = RqreVote.new(rqre_vote_params)
      rqre_vote['user_id'] = @user.id
      rqre_vote['freezed'] = '0'
      rqre_vote.save!
    else
      #update 
      rqre_vote['answer'] = params[:answer]
      rqre_vote['freezed'] = '0'
      rqre_vote.save!
    end
  end
  
  def confirm
    #show a questionnaire
    id = params[:id]
    @rqre_questionnaire = RqreQuestionnaire.find(id)

    #show questions
    #sort with question title (title may begin with sort key)
    @rqre_questions = RqreQuestion.where("rqre_questionnaire_id = ?", id).order(title: :asc)

    #find existing answer
    @rqre_votes = RqreVote.where(rqre_questionnaire_id: id, user_id: @user.id)
  end

  def vote_freeze
    #show a questionnaire
    id = params[:id]
    @rqre_questionnaire = RqreQuestionnaire.find(id)

    #show questions
    #sort with question title (title may begin with sort key)
    @rqre_questions = RqreQuestion.where("rqre_questionnaire_id = ?", id).order(title: :asc)

    #find existing answer
    @rqre_votes = RqreVote.where(rqre_questionnaire_id: id, user_id: @user.id)
    @rqre_votes.update(freezed: '1')

    vote0 = RqreVote.where(rqre_questionnaire_id: id, user_id: @user.id, rqre_question_id: '0').first
    if vote0.nil?
      #new
      vote0 = RqreVote.new
      vote0['rqre_questionnaire_id'] = id
      vote0['rqre_question_id'] = '0'
      vote0['user_id'] = @user.id
      vote0['freezed'] = '1'
      vote0.save!
    else
      #update 
      vote0['freezed'] = '1'
      vote0.save!
    end

    redirect_to project_rqre_questionnaires_path(@project)
  end

  #def vote
  #  @rqre_index = params[:rqre_index].to_i
  #  
  #  puts '======'

  #  id = params[:id]
  #  @rqre_questionnaire = RqreQuestionnaire.find(id)
  #  @rqre_questions = RqreQuestion.where("rqre_questionnaire_id = ?", id).order(title: :asc)

    
    #render confirm page
  #  if  @rqre_index >= @rqre_questions.length
  #    puts '======@rqre_index > @rqre_questions.length'
  #    flash[:notice] = l(:notice_successful_update)
  #    redirect_to project_rqre_questionnaire_path(@project, id)
    
    #render initial question
  #  else

  #    @rqre_question = @rqre_questions[@rqre_index]
  #    @rqre_vote = RqreVote.where(rqre_questionnaire_id: id, rqre_question_id: @rqre_question.id, user_id: @user.id).first

        #create vote record or update
  #      if @rqre_vote.nil?
  #        @rqre_vote = RqreVote.new
  #      end

  #      unless params[:answer].nil?
  #        @rqre_vote.update(rqre_vote_params)
  #        @rqre_vote.save!
  #      end
  #  end

    
    
    #unless params[:answer].nil?
    #  rqre_vote = RqreVote.update(rqre_questionnaire_params)
    #  rqre_vote.save!
    #end


    
      #new
      
      #render partial: 'vote'

    #else
    #  #update 
    #  rqre_vote['answer'] = params[:answer]
    #  rqre_vote['freezed'] = '0'
    #  rqre_vote.save!
    #end

  #end


  def delete
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

  def rqre_questionnaire_params
    params.require(:rqre_questionnaires).permit(:project_id,:title,:note,:description,:revote,:end)
  end

  def rqre_vote_params
    params.permit(:rqre_questionnaire_id, :rqre_question_id, :answer)
    #params.require(:rqre_vote).permit(:rqre_question_id,:user_id,:answer)
  end

end

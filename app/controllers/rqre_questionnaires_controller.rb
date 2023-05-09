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

  end
  
  def show
    #show a questionnaire
    id = params[:id]
    @rqre_questionnaire = RqreQuestionnaire.find(id)
    
    if vote_revote?(id)
    else
      redirect_to project_rqre_questionnaires_path(@project)
    end

    #show questions
    #sort with question title (title may begin with sort key)
    @rqre_questions = RqreQuestion.where("rqre_questionnaire_id = ?", id).order(title: :asc)

    #find existing answer
    @rqre_votes = RqreVote.where(rqre_questionnaire_id: id, user_id: @user.id).pluck(:rqre_question_id, :answer)
  end

  def result
    id = params[:id]

    if vote_exist?(id,@user.id) then

      @rqre_questionnaire = RqreQuestionnaire.find(id)
      @rqre_questions = RqreQuestion.where("rqre_questionnaire_id = ?", id).order(title: :asc)
      @rqre_votes = RqreVote.where(rqre_questionnaire_id: id, freezed: '1')


      #gon.rqre_votes = @rqre_votes
      gon.rqre_questions = @rqre_questions
      
      gon.rqre_votes = {}
      @rqre_votes.each do |v|
        if gon.rqre_votes[v.rqre_question_id].nil?
          gon.rqre_votes[v.rqre_question_id] =[]
        end 
        gon.rqre_votes[v.rqre_question_id] = gon.rqre_votes[v.rqre_question_id].push(v.answer)
      end

    #without existing vote 
    elsif
      #redirect to vote page
      redirect_to project_rqre_questionnaire_path(@project, id)
    end
  end


  def edit
    @rqre_questionnaire = RqreQuestionnaire.find(params[:id])
    @rqre_questions = RqreQuestion.where("questionnaire_id = ?", params[:id])
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

    rqre_vote = RqreVote.where(rqre_question_id: params[:rqre_question_id], user_id: @user.id).first
    

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


    respond_to do |format|
      format.html
      format.xml  { render :xml => @rqre_votes }
      format.json { render :json => @rqre_votes }
    end
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


  def vote_exist?(id, userid)
    rqre_vote = RqreVote.where(rqre_questionnaire_id: id, rqre_question_id: '0', freezed: '1', user_id: @user.id).first

    if rqre_vote.nil?
      return false
    else
      return true
    end
  end

  def vote_revote?(id)
    rqre_qusetionnaire = RqreQuestionnaire.find(id)

    if Time.now <= rqre_qusetionnaire.end 
      if rqre_qusetionnaire.revote?
        return true
      else
        return false
      end
    else
      return false
    end
    
  end

  def rqre_questionnaire_params
    params.require(:rqre_questionnaires).permit(:project_id,:title,:note,:description,:revote,:end)
  end

  def rqre_vote_params
    params.permit(:rqre_questionnaire_id, :rqre_question_id, :answer)
  end

end

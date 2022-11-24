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
    @rqre_votes = RqreVote.where(questionnaire_id: @rqre_questionnaires.ids, question_id: '0', fixed: '1')
    puts '----rqre1'
  end
  
  def show
    id = params[:id]
    @rqre_questionnaire = RqreQuestionnaire.find(id)
    @rqre_questions = RqreQuestion.where("questionnaire_id = ?", id).order(title: :asc)

    #sort with title (title should begin with sort key)
    #@rqre_questions = @rqre_questions
   # @rqre_questions = @rqre_questionnaire.question
    puts '----rqre2222'
  end

  def result
    id = params[:id]
    @rqre_questionnaire = RqreQuestionnaire.find(id)
    @rqre_questions = RqreQuestion.where("questionnaire_id = ?", id).order(title: :asc)
    @rqre_votes = RqreVote.where(questionnaire_id: id, fixed: '1')

    @rqre_data = {}
    @rqre_votes.each do |v|
      if @rqre_data[v.question_id].nil?
        @rqre_data[v.question_id] =[]
      end 
      @rqre_data[v.question_id] = @rqre_data[v.question_id].push(v.answer)
    end
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
end

class RqreQuestionsController < ApplicationController
  unloadable
  #before_action :require_login
  before_action :find_user
  before_action :find_project, :except => [:show, :edit, :update, :destroy, :result_question]
  before_action :find_rqre_questionnaire, :except => [:show, :edit, :update, :destroy, :result_question]
  #before_action :authorize


  def index
  end

  def show
    @rqre_question = RqreQuestion.find(params[:id])
  end

  def edit
    @rqre_question = RqreQuestion.find(params[:id])
  end
  

  def new
    @rqre_question = RqreQuestion.new
    puts '-----------------rqre_quesiton_1'
  end

  def create
    unless params[:rqre_question].nil?
      rqre_question = RqreQuestion.create(rqre_question_params)
      rqre_question['rqre_questionnaire_id'] = @rqre_questionnaire.id
      rqre_question.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_rqre_questionnaire_path(@project, @rqre_questionnaire.id)
    end
  end

  def update
    unless params[:rqre_question].nil?
      rqre_question = RqreQuestion.find(params[:id])
      
      rqre_question.update(rqre_question_params)
      rqre_question.save
      flash[:notice] = l(:notice_successful_update)

      rqre_questionnaire = RqreQuestionnaire.find(rqre_question.rqre_questionnaire_id)
      redirect_to project_rqre_questionnaire_path(rqre_questionnaire.project_id, rqre_questionnaire)
    end
  end

  def destroy
    rqre_question = RqreQuestion.find(params[:id])
    rqre_questionnaire = RqreQuestionnaire.find(rqre_question.rqre_questionnaire_id)
    project = Project.find(rqre_questionnaire.project_id)
    
    (render_403; return false) unless User.current.allowed_to?(:rqre_questionnaires_edit, project)

    
    rqre_question.destroy
    flash[:notice] = l(:notice_successful_delete)
    redirect_to project_rqre_questionnaire_path(rqre_questionnaire.project_id, rqre_questionnaire)
  end

  def result_question
    @rqre_question = RqreQuestion.find(params[:id])
    result_question = @rqre_question.rqre_votes.select(:answer).to_a
    #aaa = result_question.to_a

    respond_to do |format|
      format.xml  { render :xml => result_question }
      format.json { render :json => result_question }
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

  def find_rqre_questionnaire
    @rqre_questionnaire = RqreQuestionnaire.find(params[:rqre_questionnaire_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
  def rqre_question_params
    params.require(:rqre_question).permit(:title,:dtype,:content,:option)
  end
end

class AnswersController < ApplicationController
  def create
    @question = Question.find params[:question_id]
    @answer = @question.answers.build(answer_params)
    # 👆 shortcut for doing 👇
    # answer = Answer.new(answer_params)
    # answer.question = question

    if @answer.save
      redirect_to question_path(@question)
    else
      # We can use render to display any template by providing their
      # beginning from the `views/` folder.
      @answers = @question.answers.order(created_at: :desc)
      render 'questions/show'
    end
  end

  def destroy
    answer = Answer.find params[:id]
    answer.destroy

    redirect_to question_path(answer.question)
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end
end

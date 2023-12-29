class CommentsController < ApplicationController
  # before_action :block_direct_access
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    if request.path == "/"
      redirect_to "/comments?page=1" 
      '''
        이렇게 하지 않으면, http://127.0.0.1:3000를 주소창에 입력해서 방문할시 http://127.0.0.1:3000/comments 가 아닌 
        http://127.0.0.1:3000로 방문하게 되어 페이지 네이션 기능을 정상적으로 사용 할 수가 없음 
        pagy_url 기능은 현재 방문 중인 url을 기준으로 params[:page]를 전달 하는 메소드이기 때문에 
        http://127.0.0.1:3000로 방문한 페이지에서는  pagy_url메소드가 정상동작하지 않음 
        따라서 최초로 http://127.0.0.1:3000입력시 http://127.0.0.1:3000/comments?page=1 으로 방문하게 끔 설정
      '''
    end
    #@comments = Comment.all
    @pagy, @comments = pagy(Comment.order(created_at: :desc),items: 45)

    respond_to do |format|
      format.html # GET요청에 응답
      format.turbo_stream #POST요청에 응답
      
    end
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to comment_url(@comment), notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to comment_url(@comment), notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body)
    end

    # def block_direct_access
    #   # 특정 조건에 따라 접근을 막는 로직
    #   if request.referer.nil? && request.path == "/"
    #     render file: 'public/404.html', status: :not_found, layout: false
    #     # 혹은
    #     # redirect_to some_other_path
    #   end
    # end
end

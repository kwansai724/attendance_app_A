class BasesController < ApplicationController
  before_action :set_base, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:index]

  def index
    @bases = Base.all
  end

  def new
    @base = Base.new
  end

  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点情報を追加しました。"
    else
      flash[:danger] = "入力データが無効です。<br>"+ @base.errors.full_messages.join("<br>")
    end
    redirect_to bases_url
  end

  def edit
  end

  def update
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報を修正しました。"
    else
      flash[:danger] = "入力データが無効です。<br>"+ @base.errors.full_messages.join("<br>")
    end
    redirect_to bases_url
  end
  
  def destroy
    @base.destroy
    flash[:success] = "#{@base.base_name}を削除しました。"
    redirect_to bases_url
  end
    

  private
  
    def set_base
      @base = Base.find(params[:id])
    end

    def base_params
      params.require(:base).permit(:base_number, :base_name, :attendance_type)
    end
end

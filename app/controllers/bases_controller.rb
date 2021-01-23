class BasesController < ApplicationController
  before_action :set_base, only: [:edit, :destroy]

  def index
    @bases = Base.all
  end

  def edit
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
end

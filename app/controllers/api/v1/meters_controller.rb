class Api::V1::MetersController < Api::V1::BaseController
  before_action :authenticate_user!

  def import
    if (params[:file]==nil)
      return
    end

    success=Meter.import_meters(params[:file])   
    if success
      render json: Meter.all
    else
      render plain: "Unable to import meters.", status: :unprocessable_entity 
    end
  end

end 


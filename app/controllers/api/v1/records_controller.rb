class Api::V1::RecordsController < Api::V1::BaseController
  before_action :authenticate_user!

  def import
    if (params[:file]==nil)
      unprocessable!
    end

    @meter = Meter.find_by reference: params[:reference]

    if (@meter)
      success = @meter.import_records(params[:file])
      if success
        render json: "Records imported successfully".to_json
        return
      end
    end
      
    unprocessable!
  end

  def unprocessable!
    render json: "Unable to import records: #{(@meter)&.errors}".to_json, status: :unprocessable_entity
  end

end
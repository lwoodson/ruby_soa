require 'service_locator'

class ExportsController < ApplicationController
  include ServiceLocator
  before_action :get_employer_ids, only: [:index]

  def index
    @exports = export_service.all
  end

  def show
    @export = export_service.find(params[:id])
  end

  def create
    begin
      export = export_service.create(params[:employer_id])
      flash[:notice] = "Successfully created export #{export.id}"
    rescue StandardError => e
      flash[:alert] = "Failed to create export"
    end
    redirect_to action: 'index'
  end

  def generate_file
    begin
      export_service.generate_file(params[:id])
      flash[:notice] = "Initiated file generation for export #{params[:id]}"
    rescue StandardError => e
      flash[:alert] = "Failed to initiate file generation"
    end
    redirect_to action: 'index'
  end

  private
  def get_employer_ids
    @employer_ids = [1,2,3,4]
  end
end

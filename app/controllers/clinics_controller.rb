class ClinicsController < ApplicationController
  def create
    authorize Clinic
    @clinic = Clinic.new(clinic_params)
    if @clinic.save
      redirect_to @clinic, notice: 'Clinic successfully created'
    else
      render :new
    end
  end

  def destroy
    authorize Clinic
    @clinic = Clinic.find(params[:id])
    if @clinic.destroy
      redirect_to clinics_url, notice: 'Clinic successfully deleted'
    else
      render :show
    end
  end

  def edit
    authorize Clinic
    @clinic = Clinic.find(params[:id])
  end

  def new
    authorize Clinic
    @clinic = Clinic.new
  end

  def update
    authorize Clinic
    @clinic = Clinic.find(params[:id])
    if @clinic.update(clinic_params)
      redirect_to clinics_url, notice: 'Clinic successfully edited'
    else
      render :edit
    end
  end

  def index
    @clinics = Clinic.all
  end

  def show
    @clinic = Clinic.find(params[:id])
    @doctors = @clinic.doctors.decorate
  end

  private

  def clinic_params
    params.require(:clinic).permit(:name)
  end

end

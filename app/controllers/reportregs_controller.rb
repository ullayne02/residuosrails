class ReportregsController < ApplicationController
  before_action :set_reportreg, only: [:show, :edit, :update, :destroy]

  # GET /reportregs
  # GET /reportregs.json
  def index
    @reportregs = Reportreg.all
  end

  # GET /reportregs/1
  # GET /reportregs/1.json
  def show
  end

  # GET /reportregs/new
  def new
    @reportreg = Reportreg.new
  end

  # GET /reportregs/1/edit
  def edit
  end

  # POST /reportregs
  # POST /reportregs.json
  def create
    @reportreg = Reportreg.new(reportreg_params)

    respond_to do |format|
      if @reportreg.save
        format.html { redirect_to @reportreg, notice: 'Reportreg was successfully created.' }
        format.json { render :show, status: :created, location: @reportreg }
      else
        format.html { render :new }
        format.json { render json: @reportreg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reportregs/1
  # PATCH/PUT /reportregs/1.json
  def update
    respond_to do |format|
      if @reportreg.update(reportreg_params)
        format.html { redirect_to @reportreg, notice: 'Reportreg was successfully updated.' }
        format.json { render :show, status: :ok, location: @reportreg }
      else
        format.html { render :edit }
        format.json { render json: @reportreg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reportregs/1
  # DELETE /reportregs/1.json
  def destroy
    @reportreg.destroy
    respond_to do |format|
      format.html { redirect_to reportregs_url, notice: 'Reportreg was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reportreg
      @reportreg = Reportreg.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reportreg_params
      params.require(:reportreg).permit(:weight, :report_id)
    end
end

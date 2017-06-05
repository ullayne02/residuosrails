class ReportcellsController < ApplicationController
  before_action :set_reportcell, only: [:show, :edit, :update, :destroy]

  # GET /reportcells
  # GET /reportcells.json
  def index
    @reportcells = Reportcell.all
  end

  # GET /reportcells/1
  # GET /reportcells/1.json
  def show
  end

  # GET /reportcells/new
  def new
    @reportcell = Reportcell.new
  end

  # GET /reportcells/1/edit
  def edit
  end

  # POST /reportcells
  # POST /reportcells.json
  def create
    @reportcell = Reportcell.new(reportcell_params)

    respond_to do |format|
      if @reportcell.save
        format.html { redirect_to @reportcell, notice: 'Reportcell was successfully created.' }
        format.json { render :show, status: :created, location: @reportcell }
      else
        format.html { render :new }
        format.json { render json: @reportcell.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reportcells/1
  # PATCH/PUT /reportcells/1.json
  def update
    respond_to do |format|
      if @reportcell.update(reportcell_params)
        format.html { redirect_to @reportcell, notice: 'Reportcell was successfully updated.' }
        format.json { render :show, status: :ok, location: @reportcell }
      else
        format.html { render :edit }
        format.json { render json: @reportcell.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reportcells/1
  # DELETE /reportcells/1.json
  def destroy
    @reportcell.destroy
    respond_to do |format|
      format.html { redirect_to reportcells_url, notice: 'Reportcell was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reportcell
      @reportcell = Reportcell.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reportcell_params
      params.require(:reportcell).permit(:dep_name, :lab_name, :res_name, :kind, :total, :onu, :state, :blend, :code, :unit, :report_id)
    end
end

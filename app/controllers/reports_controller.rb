class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  
  @begin_datetime
  @end_datetime

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)
    
    if report_params[:begin_dt] == nil and report_params[:end_dt] == nil then
      @begin_datetime = Time.new(report_params["begin_dt(1i)"].to_i, report_params["begin_dt(2i)"].to_i, report_params["begin_dt(3i)"].to_i, report_params["begin_dt(4i)"].to_i, report_params["begin_dt(5i)"].to_i)
      @end_datetime = Time.new(report_params["end_dt(1i)"].to_i, report_params["end_dt(2i)"].to_i, report_params["end_dt(3i)"].to_i, report_params["end_dt(4i)"].to_i, report_params["end_dt(5i)"].to_i)
    else 
      @begin_datetime = report_params[:begin_dt].to_date
      @end_datetime = report_params[:end_dt].to_date
    end
    
    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
        case report_params[:generate_by].to_i
          when 0  #relatório por coleção
            generate_by_collection
          when 1  #relatório por departamento
            generate_by_department
          when 2  #relatório por laboratórios
            generate_by_laboratory
          when 3 #relatório por residuos
            generate_by_residue
        end
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def generate_by_department
    report_params[:list].each do |dep_name|
      if dep_name == "" then
        next
      end
      dep = Department.find_by(name: dep_name)
      dep.laboratories.each do |lab|
        lab.residues.each do |res|
          repc = @report.reportcells.find_by(res_name: res.name, dep_name: dep_name)
          if repc == nil then
            repc = Reportcell.create(dep_name: dep_name, res_name: res.name, total: 0, report_id: @report.id)
          end
          add_constraint(repc, res, add_registers(res).sum(:weight))
        end
      end
    end
  end
  
  def generate_by_laboratory
    report_params[:list].each do |lab_name|
      if lab_name == "" then
        next
      end
      lab = Laboratory.find_by(name: lab_name)
      lab.residues.each do |res|
        repc = Reportcell.create(lab_name: lab_name, res_name: res.name, total: 0, report_id: @report.id)
        add_constraint(repc, res, add_registers(res).sum(:weight))
      end
    end
  end
  
  def generate_by_residue
    report_params[:list].each do |res_name|
      if res_name == "" then
        next
      end
      Residue.where(name: res_name).each do |res|
        repc = @report.reportcells.find_by(res_name: res_name)
        if repc == nil then
          repc = Reportcell.create(res_name: res.name, total: 0, report_id: @report.id)
        end
        add_constraint(repc, res, add_registers(res).sum(:weight))
      end
    end
  end
  
  def add_registers(res)
    regs = res.registers.where(created_at: [@begin_datetime..@end_datetime]).order(:created_at)
    regs.each do |reg|
      @report.reportregs.create(weight: reg.weight)
      last_reg = @report.reportregs.last
      last_reg.created_at = reg.created_at
      last_reg.save
    end
    regs
  end
  
  def add_constraint(repc, res, total)
    repc.blend = (@report.blend ? res.blend : nil)
    repc.code = (@report.code ? res.code : nil)
    repc.kind = (@report.kind ? res.kind : nil) 
    repc.onu = (@report.onu ? res.onu : nil)
    repc.state = (@report.state ? res.kind[0] : nil)
    repc.unit = (@report.unit ? "Kg" : nil)
    repc.total = (@report.total ? repc.total + total : nil)
    repc.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:generate_by, :begin_dt, :end_dt, :unit, :state, :kind, :onu, :blend, :code, :total, :collection_id, list: [])
    end
end

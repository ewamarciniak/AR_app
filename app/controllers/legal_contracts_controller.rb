class LegalContractsController < ApplicationController
  # GET /legal_contracts
  # GET /legal_contracts.json
  def index
    @legal_contracts = LegalContract.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @legal_contracts }
    end
  end

  # GET /legal_contracts/1
  # GET /legal_contracts/1.json
  def show
    @legal_contract = LegalContract.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @legal_contract }
    end
  end

  # GET /legal_contracts/new
  # GET /legal_contracts/new.json
  def new
    @legal_contract = LegalContract.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @legal_contract }
    end
  end

  # GET /legal_contracts/1/edit
  def edit
    @legal_contract = LegalContract.find(params[:id])
  end

  # POST /legal_contracts
  # POST /legal_contracts.json
  def create
    @legal_contract = LegalContract.new(params[:legal_contract])

    respond_to do |format|
      if @legal_contract.save
        format.html { redirect_to @legal_contract, notice: 'Legal contract was successfully created.' }
        format.json { render json: @legal_contract, status: :created, location: @legal_contract }
      else
        format.html { render action: "new" }
        format.json { render json: @legal_contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /legal_contracts/1
  # PUT /legal_contracts/1.json
  def update
    @legal_contract = LegalContract.find(params[:id])

    respond_to do |format|
      if @legal_contract.update_attributes(params[:legal_contract])
        format.html { redirect_to @legal_contract, notice: 'Legal contract was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @legal_contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /legal_contracts/1
  # DELETE /legal_contracts/1.json
  def destroy
    @legal_contract = LegalContract.find(params[:id])
    @legal_contract.destroy

    respond_to do |format|
      format.html { redirect_to legal_contracts_url }
      format.json { head :no_content }
    end
  end
end

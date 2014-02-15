class TicketsController < ApplicationController
  before_action :only_teachers

  def index

    membership     = Member.select("project_id").where(user_id: current_user.id)
    currentProject = Project.select("id, max_clients, use_max_clients, max_high_priority_clients, max_medium_priority_clients, max_low_priority_clients").where(is_active: true, id: membership).first
            
    highPriority = Priority.where("name = 'high'").first.id
    midPriority  = Priority.where("name = 'medium'").first.id
    lowPriority  = Priority.where("name = 'low'").first.id

    if params[:ajax] == "update"
      updates = Ticket.updates(params[:timestamp])      
      
    elsif params[:ajax] == "getClient"      
      
      if currentProject.nil? # No current project
        updates = {"Error" => "There is not a current project!"}          
            
      else  
        if currentProject.use_max_clients
          # Check to see if the user has the max number of clients
          if Ticket.where("user_id = ?", current_user.id).size >= currentProject.max_clients
            updates = { "error" => "You have reached the maximum number of clients!"}
            allowed = false
          else 
            allowed = true
          end  
        else
          
          requested_ticket_priority_id = Ticket.find(params[:clientID]).priority_id
                    
          case (requested_ticket_priority_id)
            when highPriority
              allowed = (@highPriority = (Ticket.where("user_id = ? AND priority_id = ?", current_user.id, highPriority)).size) < currentProject.max_high_priority_clients
            when midPriority
              allowed = (@midPriority = (Ticket.where("user_id = ? AND priority_id = ?", current_user.id, midPriority)).size) < currentProject.max_medium_priority_clients
            when lowPriority
              allowed = (@lowPriority = (Ticket.where("user_id = ? AND priority_id = ?", current_user.id, lowPriority)).size) < currentProject.max_low_priority_clients
            else            
              allowed = false
          end 
        end  
          
        if allowed          
          grabbedTicket = false
          ticket        = nil          
          Ticket.transaction do                                      
            #ticket = Ticket.where("client_id = ? AND project_id = ?", params[:clientID], currentProject.id).lock(true).first
            ticket = Ticket.where("id = ? ",params[:clientID]).lock(true).first
            
            if ticket.nil?
              updates = {"Error" => "Ticket does not exist for the current project"}
            else 
               # User is allowed to get a new client: Try to grab the client ticket               
               if ticket.user_id.nil? || ticket.user_id == 0
                 ticket.user_id = current_user.id
                 ticket.save!
                 updates = { "Success" => "You got the client"}     
                 grabbedTicket = true         
               else 
                 updates = {"Someone already grabbed that client!!" => "(o_o')"}              
               end   
            end
          end            
          
          # This is done down here to allow the transaction above to finish as quickly as possible thus allowing the user to better grab the ticket
          if grabbedTicket
            receipt = Receipt.where("ticket_id = ? AND user_id = ?", ticket.id, current_user.id).first
            
            if receipt.nil?
              Receipt.create(ticket_id: ticket.id, user_id: current_user.id)
            end              
          end    
        else 
          s = requested_ticket_priority_id.to_s
          updates = {"You already have the max number of " + s => "you fail at life"}
        end              
      end 
     
    ## Added by Noah, ugly check for existence of current project, can remove once we've 
    ## cleaned up the program  
    elsif currentProject  
              
      @tickets = Ticket.current_project(currentProject.id)
      
      if currentProject.use_max_clients
        @clientsLeft = currentProject.max_clients - Ticket.where("user_id = ? AND project_id = ?", current_user.id, currentProject.id).size      
      else                
        @highPriority = currentProject.max_high_priority_clients   - Ticket.where("user_id = ? AND priority_id = ?", current_user.id, highPriority).size
        @midPriority  = currentProject.max_medium_priority_clients - Ticket.where("user_id = ? AND priority_id = ?", current_user.id, midPriority).size
        @lowPriority  = currentProject.max_low_priority_clients    - Ticket.where("user_id = ? AND priority_id = ?", current_user.id, lowPriority).size  
      end
       
      @debug = currentProject           
    end
    
    respond_to do |format|      
        format.html 
        format.json { render json: updates}
    end    
        
  end

  def show
  end

  def new
    @ticket = Ticket.new
  end

  def create
    clients = Client.house
    clients.each do |c|
       ticket = c.tickets.create(
         project_id: get_selected_project.id,
         priority_id: 2,       # Will need a method to calculate)
         user_id: c.submitter) 
       ticket.save
    end
    respond_to do |format|
        format.html { redirect_to users_url, notice: 'Ticket was successfully created.' }
    end
  end

  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def assign_user
    current_user = 1
    ticket.user_id = current_user
    ticket.save
    respond_to do |format|
        format.html { redirect_to clients_url, notice: 'Client was successfully added.' }
    end
  end

  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url }
    end
  end
  
  private
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:id, :created_at, :updated_at,                                    :project_id, 
                                     :client_id, :user_id, :priority_id)
    end
end
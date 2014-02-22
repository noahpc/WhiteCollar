module ClientsHelper
  
  def ticket_taken(cid) 
    ticket = Ticket.where(client_id: cid, project_id: get_selected_project.id).first  
  
    if ticket
      if ticket.user_id != 0 && ticket.user_id != nil
        false
      else
        ticket.user_id
      end
    else 
      true
    end        
  end
  
end

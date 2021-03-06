class Receipt < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  has_many   :actions, dependent: :destroy
  has_one    :client, through: :tickets
  has_paper_trail
  

  validates :page_size, :sale_value,
     allow_blank: true,
	 allow_nil:   true,
     length: {
        maximum: 20,
		message: 'can have a maximum of 6 digits. Please turn Javascript back on.'
  }
  
  # Returns all the receipts for the selected project
  def self.selected_project_receipts(project)
    
    tickets = Ticket.current_project(project.id)
    receipts = []
    
    tickets.each do |ticket|
      receipts << ticket.receipts unless ticket.receipts == nil
    end
    
    return receipts
  end

  def self.open_clients(student_id, project)
    Receipt.where(user_id: student_id, made_sale: false, ticket_id: Ticket.where(project_id: project), ticket_id: Ticket.where(user_id: student_id))
  end
  
  def self.sold_clients(student_id, project)
    Receipt.where(user_id: student_id, made_sale: true, ticket_id: Ticket.where(project_id: project))
  end

  def self.all_sold_clients_in_section(project, section_number="All")
    if section_number != "All"
      Receipt.where(made_sale: true, ticket_id: Ticket.where(project_id: project.id)) & Receipt.where(user_id: User.where(id: Member.where(section_number: section_number).pluck(:user_id)))
    else
      Receipt.where(made_sale: true, ticket_id: Ticket.where(project_id: project.id))
    end

  end
 
  def self.released_clients(student_id, project)
    Receipt.where(user_id: student_id, ticket_id: Ticket.where(project_id: project)) - Receipt.where(user_id: student_id, ticket_id: Ticket.where(project_id: project), ticket_id: Ticket.where(user_id: student_id)) 
  end
  
  def self.is_released(receipt)
    (receipt.made_sale != true && receipt.user_id != receipt.ticket.user_id)
  end

  def self.sales_total(student_id, project)
    sales = self.sold_clients(student_id, project)
    money = 0
    sales.each do |s|
      money += s.sale_value
    end
    return money
  end
 
  def self.points_total(student_id, project)
    receipts = Receipt.where(user_id: student_id, ticket_id: Ticket.where(project_id: project))
    points = 0

    for index in 0..(receipts.size - 1)
      receipts[index].actions.each do |a|
        points += a.points_earned        
      end
    end
    
    return points + Bonuses.get_student_bonus_total(student_id, project.id) 
  end
  
  def self.release!
    self.ticket.user_id = nil
  end
    
  def self.get_sold_receipts_for_client_up_to_project(client, project)
    client.receipts.where(made_sale: true, ticket_id: client.tickets.where(project_id: Project.where("semester = ? AND year < ? OR semester = ? AND year < ?", "Spring", (project.year), "Fall", (project.year - 1)).ids))
  end

  # This returns the total list of years that the client has bought up to the current project year
  def self.years_client_has_bought_class(client, project)
    arrow    = Project.where(id: 
               Ticket.where(id: client.receipts.where(made_sale: true, ticket_id: client.tickets.where(project_id: 
               Project.where("year <= ? AND project_type_id = ?", (project.year), 
               ProjectType.find_by(name: "Arrow")).ids)).pluck(:ticket_id)).pluck(:project_id)).pluck(:year).sort
               
    calendar = Project.where(id: 
               Ticket.where(id: client.receipts.where(made_sale: true, ticket_id: client.tickets.where(project_id: 
               Project.where("year <= ? AND project_type_id = ?", (project.year), 
               ProjectType.find_by(name: "Calendar")).ids)).pluck(:ticket_id)).pluck(:project_id)).pluck(:year).sort
               
    return arrow, calendar
  end
  
  
  # Using specialized versions of these functions for the show page - NPC
  def self.early_sale_years(client)
    arrow    = Project.where(id: 
               Ticket.where(id: client.receipts.where(made_sale: true, ticket_id: client.tickets.where(project_id: 
               Project.where("year <= ? AND project_type_id = ?", LAST_NON_ADIT_ARROW_YEAR, 
               ProjectType.find_by(name: "Arrow")).ids)).pluck(:ticket_id)).pluck(:project_id)).pluck(:year).sort
               
    calendar = Project.where(id: 
               Ticket.where(id: client.receipts.where(made_sale: true, ticket_id: client.tickets.where(project_id: 
               Project.where("year <= ? AND project_type_id = ?", LAST_NON_ADIT_CALENDAR_YEAR, 
               ProjectType.find_by(name: "Calendar")).ids)).pluck(:ticket_id)).pluck(:project_id)).pluck(:year).sort

    return arrow, calendar
  end
  
  # This only returns the sales that were after the archived projects
  def self.sales_for_client_up_to_project(client, project)
    client.receipts.where(made_sale: true, ticket_id: 
    client.tickets.where(project_id: 
       Project.where("year < ? AND  (year > ? AND project_type_id = ?) OR (year > ? AND project_type_id = ?)", 
                      project.year, LAST_NON_ADIT_ARROW_YEAR, ProjectType.find_by(name: "Arrow"), 
                                    LAST_NON_ADIT_CALENDAR_YEAR, ProjectType.find_by(name: "Calendar")).ids))
  end
  
end


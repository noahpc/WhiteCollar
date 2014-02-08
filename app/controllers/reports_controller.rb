class ReportsController < ApplicationController
  
  def sales
       Struct.new("Sale", :student_id, :manager_id, :time_of_sale, :company, :page_size,
                            :sale_amount, :name, :team_leader, :payment_type, 
                            :ad_status)
       
       @sales = []                     
       index = 0
       # Changed function name to all sold clients because error was thrown
       @sold_receipts = Receipt.all_sold_clients(get_selected_project)

       @sold_receipts.each do |r|
          @sales[index] = Struct::Sale.new
          @sales[index].student_id = r.user_id
          # @sales[index].manager_id = User.get_manager_name((r.user_id), get_selected_project).id  << Add this when ready for it
          @sales[index].time_of_sale = r.updated_at
          @sales[index].company = Client.find(Ticket.find(r.ticket_id).client_id).business_name
          @sales[index].page_size = r.page_size
          @sales[index].sale_amount = r.sale_value
          @sales[index].name = User.find(r.user_id).first_name + " " + User.find(r.user_id).last_name
          @sales[index].team_leader = User.get_manager_name((r.user_id), get_selected_project)
          @sales[index].payment_type = r.payment_type
          if (Action.find_by(receipt_id: r.id).action_type_id)
            @sales[index].ad_status = ActionType.find(Action.find_by(receipt_id: r.id).action_type_id).name
          end
          index = index + 1
       end
  end
  
  # GET reports/student_summary
  def student_summary
    
       Struct.new("Student", :id, :first_name, :last_name, :student_manager,
                            :section, :open, :sold, :released, :sales, 
                            :points, :last_activity)
       
       @student_array = []                     
       index = 0
       @receipts = Receipt.selected_project_receipts(get_selected_project)
       @students = User.current_student_users(get_selected_project, get_selected_section)
       
       @students.each do |s|
          @student_array[index] = Struct::Student.new
          @student_array[index].id = s.id
          @student_array[index].first_name = s.first_name
          @student_array[index].last_name = s.last_name
          @student_array[index].student_manager = User.get_manager_name(s.id, get_selected_project)
          @student_array[index].section = User.get_section_number(s.id, get_selected_project)
          @student_array[index].open = (Receipt.open_clients(s.id, get_selected_project)).size
          @student_array[index].sold = (Receipt.sold_clients(s.id, get_selected_project)).size
          @student_array[index].released = (Receipt.released_clients(s.id, get_selected_project)).size
          @student_array[index].sales = Receipt.sales_total(s.id, get_selected_project)
          @student_array[index].points = Receipt.points_total(s.id, get_selected_project)
          @student_array[index].last_activity = Action.get_last_activity(s.id, get_selected_project)

          index = index + 1
       end
  end
  
  # GET reports/team_summary
  def team_summary
    
  end
  
  def activities
       Struct.new("Activity", :student_id, :manager_id, :time_of_activity, :name, :team_leader,
                            :company, :activity, :comments,  :points_earned, :cumulative_points_earned_on_client)


       @activities = []                     
       index = 0
       @all_project_activities = Action.all_actions_in_project(get_selected_project)
       render text: @activities

       @all_project_activities.each do |a|
        total_points = 0
        @activities[index] = Struct::Activity.new
        @activities[index].student_id = Receipt.find(a.receipt_id).user_id
        # @activities[index].manager_id = User.get_manager_name((r.user_id), get_selected_project).id  << Add this when ready for it
        @activities[index].time_of_activity = a.user_action_time
        @activities[index].name = User.find(Receipt.find(a.receipt_id).user_id).first_name + " " + User.find(Receipt.find(a.receipt_id).user_id).last_name
        @activities[index].team_leader = User.get_manager_name((Receipt.find(a.receipt_id).user_id), get_selected_project)
        @activities[index].company = Client.find(Ticket.find(Receipt.find(a.receipt_id).ticket_id).client_id).business_name
        @activities[index].activity = ActionType.find(a.action_type_id).name
        @activities[index].comments = a.comment
        @activities[index].points_earned = a.points_earned


        @activities[index].cumulative_points_earned_on_client = total_points
        index = index + 1
       end
  end
  
private

   def get_student_summary
     User.current_student_users(get_selected_project, get_selected_section)
   end
  
end
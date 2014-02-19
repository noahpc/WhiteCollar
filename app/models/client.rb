class Client < ActiveRecord::Base
  has_many :tickets
  belongs_to :statuses

# Validates the business name
  validates :business_name, presence: true, uniqueness: true
   
# Validates the address
  validates :address, presence: true
   
# Validates the city
  validates :city, presence: true, format: {
    with: /\A[-a-zA-Z]+\z/,
    message: 'must only have letters (no digits).'
  }
 
# Validates the zipcode
  validates :zipcode, presence: true, length:{
    minimum: 5, maximum: 5,
    message: 'is the wrong length.  Needs to be only five digits long.'
  }, numericality: { greater_than: 0 }
   
# Validaates the email
  validates :email, allow_blank: true, uniqueness: true, format: {
    with: /\A([0-9a-zA-Z]+[-._+&amp;])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}\z/,
    message: 'must be a valid email address.'
  }
   
# Validates the contact first and last name
  validates :contact_fname, :contact_lname, format: {
    with: /\A[-a-zA-Z]+\z/,
    message: 'must only have letters (no digits).'
  }
   
# Validates the telephone
  validates :telephone, presence: true, uniqueness: true, format: {
    with: /\A(17\s*-\s*\d{4}\s*-\s*[1-4]|(\d{3}\s*-\s*){1,2}\d{4}(\s*[Ee][Xx][Tt]\.?\s*\d{1,7})?)\Z/,
    message: 'must be a valid telephone number.'
  }

   # Returns all pending clients, needs to be refactored to remove magic number
  def self.pending
    where(status_id: 4).all
  end

  def self.edited_pending
    where(status_id: 5).all
  end
   
  def self.unapprove
    where(status_id: 1).all
  end
   
  def self.house
    where(status_id: [3,2]).all
  end
   
  def Client.approve_clients(status, array_of_pending_clients)
    for i in 0..array_of_pending_clients.count-1
      pending_client = Client.find(array_of_pending_clients[i].to_i)
      pending_client.status_id = status
      pending_client.save
    end
  end

  def Client.approve_edited_clients(status, array_of_edited_pending_clients)
    for i in 0..array_of_edited_pending_clients.count-1
      pending_edited_client = Client.find(array_of_edited_pending_clients[i][0].to_i)
      current_client = Clint.find(array_of_edited_pending_clients[i][1].to_i)
      if status == 2
        current_client = pending_edited_client.attributes.except(:id, :created_at, :updated_at)
        current_client.save
      else
        pending_edited_client.delete
      end
    end
  end

end

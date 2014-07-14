class ContactsController < ApplicationController

  def index
    render json: as_json(contacts)
  end

  def show
    render json: as_json(contact)
  end

  def create
    @contact = Contact.create contact_params
    push "#{contacts_path}:created" if contact.valid?
    render json: as_json(contact), status: valid_status(:created)
  end

  def update
    contact.update contact_params
    push "#{contact_path(contact)}:updated" if contact.valid?
    render json: as_json(contact), status: valid_status
  end

  def destroy
    contact.destroy
    push "#{contacts_path}:destroyed"
    render json: as_json(contact)
  end

  private

    def address_attributes
      [:id, :street, :city, :state, :postcode]
    end

    def as_json(model)
      model.as_json only: contact_attributes, methods: [:age, :errors, :gravatar_hash], include: { address: { only: address_attributes } }
    end

    def contact
      @contact ||= Contact.find params[:id]
    end

    def contacts
      @contacts ||= Contact.includes(:address).to_a
    end

    def contact_attributes
      [:id, :name, :sex, :birthday, :phone, :email]
    end

    def contact_params
      params[:contact].permit :id, :name, :sex, :birthday, :phone, :email, address_attributes: [:id, :street, :city, :state, :postcode]
    end

    def push(event)
      $pusher.trigger event, as_json(contact)
    end

    def valid_status(status=:ok)
      contact.valid? ? status : :unprocessable_entity
    end
end

require 'spec_helper'

describe ContactsController do
  let(:contact_params) { attributes_for :contact }
  let(:address_params) { attributes_for :address }

  context 'with multipled existing contacts' do
    let!(:contacts) { 3.times.map { create :contact } }

    describe 'GET #index' do
      before { get :index }

      it "finds the contacts ordered by name" do
        assigns(:contacts).should eq contacts.sort_by(&:name)
      end
    end
  end

  context 'with an existing contact' do
    let!(:contact) { create :contact }

    describe 'GET #show' do
      before { get :show, id: contact.id }

      it "finds the contact" do
        assigns(:contact).should eq contact
      end
    end

    describe 'PUT #update' do
      def update
        put :update, id: contact.id, contact: { name: new_name }
      end

      context 'with valid params' do
        let(:new_name) { 'New name' }

        it "updates the contact" do
          update
          Contact.find(contact.id).name.should eq new_name
        end

        it "responds with 200 :ok" do
          update
          expect(response.status).to eq 200
        end

        it "triggers an updated event on Pusher" do
          expect($pusher).to receive(:trigger).with 'contact:updated', instance_of(Hash)
          update
        end
      end

      context 'with invalid params' do
        let(:new_name) { '' }

        it "doesn't update the contact" do
          update
          Contact.find(contact.id).name.should_not eq new_name
        end

        it "responds with 422 :unprocessable_entity" do
          update
          expect(response.status).to eq 422
        end

        it "doesn't trigger an even on Pusher" do
          expect($pusher).not_to receive(:trigger)
          update
        end
      end
    end

    describe 'DELETE #destroy' do
      def destroy
        delete :destroy, id: contact.id
      end

      it "destroys the contact" do
        expect { destroy }.to change(Contact, :count).by(-1)
      end

      it "triggers a destroyed event on Pusher" do
        expect($pusher).to receive(:trigger).with 'contact:destroyed', instance_of(Hash)
        destroy
      end
    end
  end

  describe 'POST #create' do
    def create
      post :create, contact: contact_params
    end

    context 'with valid params' do
      it "creates a new contact" do
        expect { create }.to change(Contact, :count).by(1)
      end

      it "responds with 201 :created" do
        create
        expect(response.status).to eq 201
      end

      it "triggers a created event on Pusher" do
        expect($pusher).to receive(:trigger).with "contact:created", instance_of(Hash)
        create
      end
    end

    context 'with invalid params' do
      before { contact_params[:name] = '' }

      it "doesn't create a new contact" do
        expect { create }.to_not change(Contact, :count)
      end

      it "responds with 422 :unprocessable_entity" do
        create
        expect(response.status).to eq 422
      end

      it "doesn't trigger an event on Pusher" do
        expect($pusher).not_to receive(:trigger)
        create
      end
    end
  end
end

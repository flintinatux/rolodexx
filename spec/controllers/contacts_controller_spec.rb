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
      context 'with valid params' do
        let(:new_name) { 'New name' }
        before { put :update, id: contact.id, contact: { name: new_name } }

        it "updates the contact" do
          Contact.find(contact.id).name.should eq new_name
        end

        it "responds with 200 :ok" do
          expect(response.status).to eq 200
        end
      end

      context 'with invalid params' do
        let(:new_name) { '' }
        before { put :update, id: contact.id, contact: { name: new_name } }

        it "doesn't update the contact" do
          Contact.find(contact.id).name.should_not eq new_name
        end

        it "responds with 422 :unprocessable_entity" do
          expect(response.status).to eq 422
        end
      end
    end

    describe 'DELETE #destroy' do
      it "destroys the contact" do
        expect { delete :destroy, id: contact.id }.to change(Contact, :count).by(-1)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it "creates a new contact" do
        expect { post :create, contact: contact_params }.to change(Contact, :count).by(1)
      end

      it "responds with 201 :created" do
        post :create, contact: contact_params
        expect(response.status).to eq 201
      end
    end

    context 'with invalid params' do
      before { contact_params[:name] = '' }

      it "doesn't create a new contact" do
        expect { post :create, contact: contact_params }.to_not change(Contact, :count)
      end

      it "responds with 422 :unprocessable_entity" do
        post :create, contact: contact_params
        expect(response.status).to eq 422
      end
    end
  end
end

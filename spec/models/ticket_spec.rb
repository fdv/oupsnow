require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Ticket do

  before :all do
    Project.gen
    State.gen(:name => 'new')
  end

  it "should be valid" do
    Ticket.gen(:project_id => Project.first.id).should be_valid
  end

  describe '#generate_update' do

    def generate_ticket(ticket)
      @t = Ticket.gen(:project_id => Project.first.id)
      @old_description = @t.description
      @old_title = @t.title
      @t.generate_update(@t.attributes.merge(ticket))
    end

    describe 'change only description' do
      before(:each) do
        generate_ticket({:description => 'new description'})
      end

      it 'should not update ticket' do
        @t.description.should_not == 'new description'
      end

      it 'should generate ticket update' do
        @t.ticket_updates.should have(1).items
      end

      it 'should generate ticket update with some description' do
        @t.ticket_updates[0].description.should == 'new description'
      end

      it 'should not have properties_update' do
        @t.ticket_updates[0].properties_update.should be_empty
      end
    end

    describe 'change only title' do
      before(:each) do
        generate_ticket({:title => 'new title', :description => ''})
      end

      it 'should update title ticket' do
        @t.title.should == 'new title'
      end

      it 'should generate ticket update' do
        @t.ticket_updates.should have(1).items
      end

      it 'should generate ticket update without description' do
        @t.ticket_updates[0].description.should be_nil
      end

      it 'should have properties_update about title' do
        @t.ticket_updates[0].properties_update.should == [[:title, @old_title, 'new title']]
      end
    end

    describe 'change title with description' do
      before(:each) do
        generate_ticket({:title => 'new title', :description => 'yahoo'})
      end

      it 'should update title ticket' do
        @t.title.should == 'new title'
      end

      it 'should not update description ticket' do
        @t.description.should_not == 'yahoo'
      end

      it 'should generate ticket update' do
        @t.ticket_updates.should have(1).items
      end

      it 'should generate ticket update with description' do
        @t.ticket_updates[0].description.should == 'yahoo'
      end

      it 'should have properties_update about title' do
        @t.ticket_updates[0].properties_update.should == [[:title, @old_title, 'new title']]
      end
    end

    describe 'change title, state with description' do
      before(:each) do
        State.all(:name => 'check').destroy!
        generate_ticket({:title => 'new title', :description => 'yahoo', :state_id => State.gen(:name => 'check').id})
      end

      it 'should update title ticket' do
        @t.title.should == 'new title'
      end

      it 'should update state of ticket' do
        @t.state_id.should == State.first(:name => 'check').id
      end

      it 'should not update description ticket' do
        @t.description.should_not == 'yahoo'
      end

      it 'should generate ticket update' do
        @t.ticket_updates.should have(1).items
      end

      it 'should generate ticket update with description' do
        @t.ticket_updates[0].description.should == 'yahoo'
      end

      it 'should have properties_update about title' do
        @t.ticket_updates[0].properties_update.should == [[:title, @old_title, 'new title'],[:state_id, State.first(:name => 'new').id, State.first(:name => 'check').id]]
      end
    end
  end

end

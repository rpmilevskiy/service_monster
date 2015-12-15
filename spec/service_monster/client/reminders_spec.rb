require 'spec_helper'

RSpec.describe ServiceMonster::Client::Reminders do
  
  before do
    @client = ServiceMonster::Client.new
  end

  describe '#reminders' do

    before do
      stub_get("reminders").to_return(
        body: fixture('reminders_list.json'),
        headers: {
          content_type: "application/json; charset=utf-8",
          authorization: 'Basic test'
        }
      )
    end

    it 'should return a list of reminders' do
      @client.reminders
      expect(a_get("reminders")).to have_been_made
    end

    context 'with filter applied' do
      before do
        stub_get("reminders?wField=endDateTime&wOperator=gt&wValue=2014-11-16T08:33:00").to_return(
          body: fixture('filtered_reminders_list.json'),
          headers: {
            content_type: "application/json; charset=utf-8",
            authorization: 'Basic test'
          }
        )
      end

      it 'should return a filtered list of reminders' do
        params = { wField: 'endDateTime', wOperator: 'gt', wValue: '2014-11-16T08:33:00' } 
        expect(@client.reminders(params)['items'].first['name']).to eq('Your next project')
      end
    end
  end

  describe '#reminder' do

    before do
      stub_get("reminders/c300d933-723f-11e3-b8c3-d9b28ac835cd").to_return(
        body: fixture('reminder.json'),
        headers: {
          content_type: "application/json; charset=utf-8",
          authorization: 'Basic test'
        }
      )
    end

    it 'should return the selected reminder' do
      @client.reminder('c300d933-723f-11e3-b8c3-d9b28ac835cd')
      expect(a_get("reminders/c300d933-723f-11e3-b8c3-d9b28ac835cd")).to have_been_made
    end
  end

end

class Rate

  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :sample_date, type: Time # sampling data is at least every 7 days
  field :state, type: String # Am I going to support other states ever?
  field :value, type: Float
  field :program, type: String # Fixed30Year, Fixed15Year, ARM5, ARM7, Fixed20Year
  
  # Read from db/loan_rates
  # Rate.create!(sample_date: Time.parse("2012-11-12T00:00:00-08:00"), value: 2.655, program: 'Fixed15Year', state: 'MA')
  # Rate.where(:sample_date.lt => Time.now).first
  
  # getRates(stats: 'MA')
  def self.getRates(options = {})
    # http://www.zillow.com/webservice/GetRateSummary.htm?zws-id=${zid}
    # http://www.zillow.com/webservice/GetRateSummary.htm?zws-id=${zid}&state=MA
    # { "request" : {  "output" : "json" }, "message" : { "text" : "Request successfully processed",
    # "code" : "0" }, "response" : { "today" : { "thirtyYearFixed" : "3.86", 
    # "thirtyYearFixedCount" : "799", "fifteenYearFixed" : "2.99", "fifteenYearFixedCount" : "603",
    # "fiveOneARM" : "2.75", "fiveOneARMCount" : "353" }, "lastWeek" : { "thirtyYearFixed" : "3.86",
    # "thirtyYearFixedCount" : "11155", "fifteenYearFixed" : "2.99", "fifteenYearFixedCount" : "8551",
    # "fiveOneARM" : "2.77", "fiveOneARMCount" : "7042" } } } 
    
    # if there is an entry in local db within an hour, use that
    # otherwise load from remote service
    state = options[:state] || 'MA'
    now = Time.now
    an_hour_ago = (now - 3600)
    rates = Rate.where(:sample_date.gt => an_hour_ago, :state => state).order_by(:sample_date.desc)
    if rates.empty?
      result = HTTParty.get("http://www.zillow.com/webservice/GetRateSummary.htm?zws-id=#{APP_CONFIG['zws_id']}&output=json&state=MA")
      if result["message"]["code"] == '0'
        Rate.create!(sample_date: now, program: 'Fixed30Year', state: state, value: result["response"]['today']['thirtyYearFixed'])
        Rate.create!(sample_date: now, program: 'Fixed15Year', state: state, value: result["response"]['today']['fifteenYearFixed'])
        Rate.create!(sample_date: now, program: 'fiveOneARM', state: state, value: result["response"]['today']['fiveOneARM'])
        rates = Rate.where(:sample_date.gt => an_hour_ago, :state => state).order_by(:sample_date.desc)
      end
    end
    
    if rates
      rates.reduce({}) do |hash_by_program, rate|
        hash_by_program[rate.program] = rate.value
        hash_by_program
      end
    end
  end
end
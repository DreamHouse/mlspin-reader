# run in the rails console
['15y', '20y', '30y', 'arm5', 'arm7'].each do |file_suffix|
  content = File.read("./db/loan_rates/rate_#{file_suffix}.txt")
  rates = JSON.parse(content)
  program = rates["rates"]["local"]["query"]["program"]
  rates["rates"]["local"]["samples"].each do |rate_entry|
    value = rate_entry["rate"]
    t = Time.parse(rate_entry["time"])
    Rate.create!(sample_date: t, value: value.to_f, program: program, state: 'MA')
  end
end
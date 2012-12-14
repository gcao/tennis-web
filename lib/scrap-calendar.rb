require 'mechanize'
require 'json'

def detect_tournament_type type_str
  case type_str
  when /250/         then 'atp250'
  when /500/         then 'atp500'
  when /1000/        then 'atp1000'
  when /grand slam/i then 'grandslam'
  when /davis/       then 'daviscup'
  else                    type_str
  end
end


agent = Mechanize.new
page = agent.get('http://www.atpworldtour.com/Tournaments/Event-Calendar.aspx')

tournaments = []
page.search('.calendarTable tr').each do |row|
  name  = row.search('td:nth-child(3) a').text.strip
  url   = row.search('td:nth-child(3) a').first.attr('href')
  place = row.search('td:nth-child(3) :nth-child(3)').text.strip

  day, month, year = row.search('td:nth-child(2)').text.split('.')
  start = Date.new(year.to_i, month.to_i, day.to_i)

  if logo = row.search('td:nth-child(1) img').first
    type = detect_tournament_type logo.attr('title')
  end

  title_holder = ''
  tournaments << {
    name:  name,
    url:   url,
    place: place,
    start: start,
    type:  type
  }
end

result = {time: Time.now, data: tournaments}

File.open('tournaments.js', 'w') do |f|
  f.puts "var tournaments = #{result.to_json};"
end


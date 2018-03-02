# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'start seeding database'

todays_date = DateTime.now
puts 'using today\'s date: ' + todays_date.to_s

puts 'creating user accounts'
u=User.create(email:"Joe@ApexLLC.com", password:"password")
puts 'done'

puts 'creating sites'
site=Site.new(name:"Office Building 1",address: "2407 SE Division st. Portland, OR 97202", website: "OfficeBuilding.com")
u.site = site
puts 'done'

u.rates << Rate.create(symbol:"kWh",rate:0.084)

puts 'creating meters'
for i in 1..12
  site.meters<<Meter.new(reference:"NAE-01:N2 Trunk 1.AHU-#{i}.DX#{i}-kwh",datatype:1,unit:"kwh")
end
puts 'done'

puts 'creating records'
for m in site.meters
  multiplier=rand(80..130)
  for i in 1..400
    m.records<<Record.new(datetime:todays_date - i,value:multiplier*(rand(0.8..1.2)))
  end
end
puts 'done'

puts 'creating tenants'
t1=Tenant.create(name:"Simple Bank Montreal",phone:"262-930-7445",email:"Montreal@SimpleBank.com")
t2=Tenant.create(name:"Strauss Family Creamery",phone:"262-930-7445",email:"yvette@strauscreamery.com")
t3=Tenant.create(name:"University of Wisconsin-Parkside",phone:"262-930-7445",email:"admin@uwp.edu")
u.tenants << [t1,t2,t3]
puts 'done'


for t in [t1,t2,t3]
  puts 'configuring meters and invoices for ' + t.name
  meter_id_1=rand(1..12)
  meter_id_2=rand(1..12)
  meter_id_3=rand(1..12)
  b1=BillableMeter.create(description: "East Office kWh #" + meter_id_1.to_s, meter_id: meter_id_1, rate_id: 1)
  b2=BillableMeter.create(description: "East Office kWh #" + meter_id_2.to_s, meter_id: meter_id_2, rate_id: 1)
  b3=BillableMeter.create(description: "East Office kWh #" + meter_id_3.to_s, meter_id: meter_id_3, rate_id: 1)
  t.billable_meters << [b1,b2,b3]
  startDate=DateTime.now.at_beginning_of_month

  for i in 1..12
    puts 'building invoice ' + i.to_s + ' of 12'
    startDate=startDate.prev_month
    endDate=startDate.next_month.prev_day
    sendDate=endDate+6

    status = "Paid"

    if (i == 1 && t!=t2)
        status = "Unpaid"
    end

    i=Invoice.create(number:i+12100,start_date:startDate,end_date:endDate,send_date:sendDate,status: status)
    i.billable_meters << t.billable_meters
    i.set_amount_due
    t.invoices << i
  end

  puts 'done'
end

puts 'done seeding database'
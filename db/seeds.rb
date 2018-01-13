# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'start seeding database'

u=User.create(email:"Joe@ApexLLC.com", password:"password")

site=Site.new(name:"Office Building 1",address: "2407 SE Division st. Portland, OR 97202", website: "OfficeBuilding.com")
u.site = site

for i in 1..12
  site.meters<<Meter.new(name:"RTU Meter #{i}", description:"East wing RTU", reference:"NAE-01:N2 Trunk 1.RHU-#{i}.RTU-kwh")
end

puts 'creating records'
for m in site.meters
  multiplier=rand(50..80)
  for i in 1..100
    m.records<<Record.new(datetime:DateTime.new(2017,12,1) + i,value:multiplier*(rand(0.8..1.2)))
  end
end
puts 'done'

t1=Tenant.create(name:"Simple Bank Montreal",phone:"262-930-7445",email:"Montreal@SimpleBank.com")
t2=Tenant.create(name:"Strauss Family Creamery",phone:"262-930-7445",email:"yvette@strauscreamery.com")
t3=Tenant.create(name:"Universety of Wisconsin-Parkside",phone:"262-930-7445",email:"admin@uwp.edu")
u.tenants << [t1,t2,t3]


for t in [t1,t2,t3]
  b1=BillableMeter.create(description: "East Office RTU #1", meter_id: 1)
  b2=BillableMeter.create(description: "East Office RTU #2", meter_id: 2)
  b3=BillableMeter.create(description: "East Office RTU #3", meter_id: 3)
  t.billable_meters << [b1,b2,b3]
  for i in 1..11
    startDate=DateTime.new(2017,i,1)
    endDate=startDate.next_month.prev_day
    sendDate=endDate+6
    i=Invoice.create(number:i+12100,start_date:startDate,end_date:endDate,send_date:sendDate,status:"Paid")
    i.billable_meters << t.billable_meters
    i.set_amount_due
    t.invoices << i
  end
    i=Invoice.create(number:12112,start_date:DateTime.new(2017,12,1),end_date:DateTime.new(2017,12,31),send_date:DateTime.new(2018,1,5),amount:2003.22,status:"Unpaid")
    i.billable_meters << t.billable_meters
    i.set_amount_due
    t.invoices << i
end

puts 'done seeding database'
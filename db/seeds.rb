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
space1=Space.new(name:"Unit 312",description:"Office Area 1")
space2=Space.new(name:"Unit 215",description:"Office Area 2")
space3=Space.new(name:"Unit 121",description:"Office Area 3")
site.spaces << [space1,space2,space3]

for i in 1..12
  site.meters<<Meter.new(name:"RTU Meter #{i}", description:"East wing RTU", reference:"NAE-01:N2 Trunk 1.RHU-#{i}.RTU-kwh")
end

for m in site.meters
  for i in 1..100
    m.records<<Record.new(datetime:DateTime.new(2017,12,1),value:i*2.223)
  end
end

space1.meters<<site.meters[0..2]
space2.meters<<site.meters[3..5]
space3.meters<<site.meters[6..8]

t1=Tenant.create(name:"Simple Bank Montreal",phone:"262-930-7445",email:"Montreal@SimpleBank.com")
t2=Tenant.create(name:"Strauss Family Creamery",phone:"262-930-7445",email:"yvette@strauscreamery.com")
t3=Tenant.create(name:"Universety of Wisconsin-Parkside",phone:"262-930-7445",email:"admin@uwp.edu")
u.tenants << [t1,t2,t3]

space1.tenant = t1
space2.tenant = t2
space3.tenant = t3

for t in [t1,t2,t3]
  for i in 1..11
    startDate=DateTime.new(2017,i,1)
    endDate=startDate.next_month.prev_day
    sendDate=endDate+6
    t.invoices << Invoice.create(number:i,start_date:startDate,end_date:endDate,send_date:sendDate,amount:10000.22*i/(i+4),status:"Paid")
  end
  t.invoices << Invoice.create(number:12,start_date:DateTime.new(2017,12,1),end_date:DateTime.new(2017,12,31),send_date:DateTime.new(2018,1,5),amount:2003.22,status:"Unpaid")
end

puts 'done seeding database'
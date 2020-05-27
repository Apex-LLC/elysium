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

puts 'creating account'
a=Account.create(name:"Test Account", billing_cycle_start_day: 1, days_until_invoice_due: 20)
puts 'done'

puts 'creating users'
u1=a.users.create(email:"Joe@ApexLLC.co", password:"password", name: "Joe Bauer", phone: "2629307445", role: :admin)
u2=a.users.create(email:"matt@withkander.com", password:"password", role: :owner)
u3=a.users.create(email:"Dave@ApexLLC.com", password:"password", role: :owner)
u4=a.users.create(email:"Brendon@ApexLLC.com", password:"password", role: :owner)
tenant_user=a.users.create(email:"tenant@withkander.com",password:"password", role: :tenant)
puts 'done'

admin_fee1 = a.admin_costs.create(label:"Admin fee 1", percent:1.2,flat_fee:nil, description: "Management fee 1")
admin_fee2 = a.admin_costs.create(label:"Admin fee 2", percent:nil,flat_fee:10.0, description: "Management fee 2")

  puts 'creating sites'
  site=Site.new(name:"Office Building 1",address: "2407 SE Division st. Portland, OR 97202", website: "OfficeBuilding.com")
  a.site = site
  puts 'done'

  a.rates << Rate.create(symbol:"kWh",rate:0.0084)

  puts 'creating meters'
  for i in 1..12
    site.meters<<Meter.new(reference:"NAE-01:N2 Trunk 1.AHU-#{i}.DX#{i}-kwh",datatype:1,unit:"kwh")
  end
  puts 'done'

  puts 'creating records'
  for m in site.meters
    multiplier=rand(80..900)
    # multiplier=0 #Uncomment this to make all the invoices have a total of 0
    value = multiplier
    date = todays_date-400
    for i in 1..400
      m.records<<Record.new(datetime:date + i, value:value)
      value = value + rand(2.5..(multiplier/10.0))
      m.records<<Record.new(datetime:(date + i)+12.hours, value:value)
      value = value + rand(2.5..(multiplier/10.0))
    end
  end
  puts 'done'

  puts 'creating tenants'
  t1=Tenant.create(name:"Simple Bank Montreal",phone:"262-930-7445",email:"Montreal@SimpleBank.com")
  t2=Tenant.create(name:"Strauss Family Creamery",phone:"262-930-7445",email:"yvette@strauscreamery.com")
  t3=Tenant.create(name:"University of Wisconsin-Parkside",phone:"262-930-7445",email:"tenant@withkander.com")
  tenant_user.tenant = t1
  tenant_user.save
  a.tenants << [t1,t2,t3]
  puts 'done'


  for t in [t1,t2,t3]
    puts 'configuring meters and invoices for ' + t.name
    meter_id_1=rand(1..4)
    meter_id_2=rand(5..8)
    meter_id_3=rand(9..12)
    b1=BillableMeter.create(description: "East Office kWh #" + meter_id_1.to_s, meter_id: meter_id_1, rate_id: 1, account_id: a.id)
    b2=BillableMeter.create(description: "East Office kWh #" + meter_id_2.to_s, meter_id: meter_id_2, rate_id: 1, account_id: a.id)
    b3=BillableMeter.create(description: "East Office kWh #" + meter_id_3.to_s, meter_id: meter_id_3, rate_id: 1, account_id: a.id)
    t.billable_meters << [b1,b2,b3]
    
    startDate=DateTime.new(DateTime.now.year,DateTime.now.month,1) 

    for x in 1..12
      puts 'building invoice ' + x.to_s + ' of 12'
      startDate=startDate.prev_month
      endDate=startDate.next_month.prev_day
      sendDate=endDate+6

      number = (startDate.year % 100) * 100000
      number = number + (startDate.month*1000)
      endNumber = 1
      if (t == t2)
        endNumber = 2
      elsif (t==t3)
        endNumber = 3
      end
      number = number + endNumber

      # if (a.invoices.count == 0)
      #   number = 20100
      # else
      #   number = a.invoices.max_by(&:number).number + 1
      # end

      i=Invoice.new(number:number,start_date:startDate,end_date:endDate,send_date: sendDate, due_date: endDate + a.days_until_invoice_due)
      i.billable_meters << t.billable_meters
      i.save

      t.invoices << i

      if (x != 1 || t==t2)
        i.set_paid
        payment = 
        Payment.new(date: i.send_date, amount: i.total, email: i.tenant.email, tenant: i.tenant, invoice: i)
        payment.save
      end
    end

    puts 'done'
  end


puts 'done seeding database'
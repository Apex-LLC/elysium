namespace :elysium do

  desc 'Say hello!'
  task :hello_world do
    puts "Hello"
  end

  desc "Generates Invoices That Are Due"
  task :generate_invoices => :environment do
    puts "Looping through each account..."
    Account.all.each do |account|
      puts "Looping through each tenant managed by " + account.name + "..."
      number = 20190401

      if (account.invoices.any?)
        number = account.invoices.last.number+1
      end

      account.tenants.each do |tenant|
        if tenant.invoice_due
          puts "An invoice is due for " + tenant.name + "."
          if (tenant.invoices.last != nil) 
            puts "The last invoice included data through " + tenant.invoices.last.end_date.to_s
          end

          puts "--"
          puts "Creating invoice for " + account.name + ": " + tenant.name + "..."

          start_date = Date.new(Date.today.year, Date.today.month, account.billing_cycle_start_day).prev_month
          end_date = start_date.next_month - 1.seconds

          invoice = tenant.invoices.new(number: number, start_date: start_date, end_date: end_date - 1.seconds, send_date: end_date + 6.days, due_date: end_date + account.days_until_invoice_due.days)
          invoice.billable_meters << tenant.billable_meters

          invoice.save
          number=number+1
          puts "done."

        end
      end
    end
  end

  desc "Generates Invoices for Past Months"
  task :generate_past_invoices, [:months] => :environment do  |task, args|
    puts "Looping through each account..."
    Account.all.each do |account|
      puts "Looping through each tenant managed by " + account.name + "..."
      account.tenants.each do |tenant|
        first_invoice_start_date=Date.new
        if (tenant.invoices.last != nil) 
          puts "The last invoice included data through " + tenant.invoices.last.end_date.to_s
          first_invoice_start_date = tenant.invoices.last.start_date.prev_month
        else          
          first_invoice_start_date = Date.new(Date.today.year, Date.today.month, account.billing_cycle_start_day).prev_month
          puts "No invoice exists for " + tenant.name + ". Creating a new one with a start date of " + first_invoice_start_date.to_s
        end

        start_date = first_invoice_start_date
        (1..args[:months].to_i).each do |months_ago|
          end_date = start_date.next_month - 1.seconds

          next if (tenant.invoices.where(start_date: start_date).exists?)

          puts "Generating invoice from " + start_date.to_s + " to " + end_date.to_s + " for " + account.name + ": " + tenant.name + "..."
          puts "--"

          invoice = tenant.invoices.new(number: 100, start_date: start_date, end_date: end_date - 1.seconds, send_date: end_date + 6, due_date: end_date + account.days_until_invoice_due)
          invoice.billable_meters << tenant.billable_meters

          invoice.save

          if (invoice.amount == 0.0)
            invoice.destroy
          end

          puts "done."

          start_date = start_date.prev_month;
        end
      end
    end
  end

end
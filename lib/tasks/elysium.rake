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
      invoice_number = 1

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

          year = end_date.year % 100
          month = '%02d' % end_date.month
          num = '%03d' % invoice_number
          number = year.to_s + month.to_s + num.to_s

          invoice = tenant.invoices.new(number: number, start_date: start_date, end_date: end_date - 1.seconds, send_date: end_date + 6, due_date: end_date + account.days_until_invoice_due.days)
          invoice.billable_meters << tenant.billable_meters

          invoice.save

          puts "done."

          start_date = start_date.prev_month;
        end
        invoice_number = invoice_number+1
      end
    end
  end

  # desc "Marks all invoices paid that are older than the newest group"
  # task :mark_old_invoices_paid => :environment do
  #   Account.all.each do |account|
  #     return if !account.invoices.any?
  #     puts "Marking invoices paid for " account.name + "..."
  #     latest_invoice_number = account.invoices.first.number
  #     account.invoices.each do |invoice|
  #       if (invoice.status == "overdue" && invoice.number < latest_invoice_number.floor(-1))
  #         invoice.set_paid
  #       end
  #     end
  #     puts "done."
  #   end
  # end

end
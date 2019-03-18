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
      account.tenants.each do |tenant|
        if tenant.invoice_due
          puts "An invoice is due for " + tenant.name + "."
          if (tenant.invoices.last != nil) 
            puts "The last invoice included data through " + tenant.invoices.last.end_date.to_s
          end

          puts "--"
          puts "Creating invoice for " + account.name + ": " + tenant.name + "..."

          start_date = Date.new(Date.today.year, Date.today.month, account.billing_cycle_start_day).prev_month
          end_date = start_date.next_month

          invoice = tenant.invoices.new(number: 100, start_date: start_date, end_date: end_date - 1.seconds, send_date: end_date + 6, due_date: end_date + account.days_until_invoice_due)
          invoice.billable_meters << tenant.billable_meters
          byebug
          invoice.save

          puts "done."

        end
      end
    end
  end

end
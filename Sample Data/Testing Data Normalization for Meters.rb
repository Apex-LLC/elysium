#Anomoly type 1 - 9
records = 
[Record.new(datetime:DateTime.now - 9, value: 90.0),
Record.new(datetime:DateTime.now - 8, value: 91.0),
Record.new(datetime:DateTime.now - 7, value: 92.0),
Record.new(datetime:DateTime.now - 6, value: 900.0),
Record.new(datetime:DateTime.now - 5, value: 94.0),
Record.new(datetime:DateTime.now - 4, value: 95.0),
Record.new(datetime:DateTime.now - 3, value: 96.0),
Record.new(datetime:DateTime.now - 2, value: 97.0),
Record.new(datetime:DateTime.now - 1, value: 98.0),
Record.new(datetime:DateTime.now, value: 99.0)]

#Reset - 102
records = 
[Record.new(datetime:DateTime.now - 9, value: 390.0),
Record.new(datetime:DateTime.now - 8, value: 391.0),
Record.new(datetime:DateTime.now - 7, value: 392.0),
Record.new(datetime:DateTime.now - 6, value: 393.0),
Record.new(datetime:DateTime.now - 5, value: 94.0),
Record.new(datetime:DateTime.now - 4, value: 95.0),
Record.new(datetime:DateTime.now - 3, value: 96.0),
Record.new(datetime:DateTime.now - 2, value: 97.0),
Record.new(datetime:DateTime.now - 1, value: 98.0),
Record.new(datetime:DateTime.now, value: 99.0)]

#Anomoly type 2 - 9
records = 
[Record.new(datetime:DateTime.now - 9, value: 90.0),
Record.new(datetime:DateTime.now - 8, value: 91.0),
Record.new(datetime:DateTime.now - 7, value: 92.0),
Record.new(datetime:DateTime.now - 6, value: 3.0),
Record.new(datetime:DateTime.now - 5, value: 94.0),
Record.new(datetime:DateTime.now - 4, value: 95.0),
Record.new(datetime:DateTime.now - 3, value: 96.0),
Record.new(datetime:DateTime.now - 2, value: 97.0),
Record.new(datetime:DateTime.now - 1, value: 98.0),
Record.new(datetime:DateTime.now, value: 99.0)]

Testing Procedure
1. #delete the previous test records from the end of the bunch
BillableMeter.last.meter.records.order('created_at DESC').limit(10).destroy_all

2.
#add records to record

3. #add records to meter
BillableMeter.last.meter.records << records

4. #verify
BillableMeter.last.get_records(DateTime.now - 10, DateTime.now)  
class Oystercard

	MAXIMUM_LIMIT = 90
	MINIMUM_FARE = 1

	attr_reader :balance, :entry_station, :exit_station, :journey_history


	def initialize(balance = 0)
		@balance = balance
		@journey_history = {}
	end

	def top_up(amount)
		raise "The maximum balance you can have is £#{MAXIMUM_LIMIT}!" if @balance + amount > MAXIMUM_LIMIT
		@balance += amount
	end

	def touch_in(station_name)
		raise 'Please top up more than £1!' if @balance < MINIMUM_FARE
		@entry_station = station_name
	end

	def touch_out(station_name)
		deduct(MINIMUM_FARE)
		@exit_station = station_name
		@journey_history[@entry_station] = @exit_station
		@entry_station = nil
	end

	def in_journey?
		entry_station
	end

	private

	def deduct(amount)
		@balance -= amount
	end


end

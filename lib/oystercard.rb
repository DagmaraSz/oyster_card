class Oystercard

	MAXIMUM_LIMIT = 90
	MINIMUM_FARE = 1

	attr_reader :balance
	attr_accessor :in_journey

	def initialize(balance = 0)
		@balance = balance
	end

	def top_up(amount)
		raise "The maximum balance you can have is £#{MAXIMUM_LIMIT}!" if @balance + amount > MAXIMUM_LIMIT
		@balance += amount
	end

	def touch_in
		raise 'Please top up more than £1!' if @balance < MINIMUM_FARE
		@in_journey = true
	end

	def touch_out
		deduct(MINIMUM_FARE)
		@in_journey = false
	end

	def in_journey?
		@in_journey
	end

	private

	def deduct(amount)
		@balance -= amount
	end

end

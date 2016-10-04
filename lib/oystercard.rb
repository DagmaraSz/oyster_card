class Oystercard

	MAXIMUM_LIMIT = 90
	MINIMUM_AMOUNT = 1

	attr_reader :balance
	attr_accessor :in_journey

	def initialize(balance = 0)
		@balance = balance
	end

	def top_up(amount)
		top_up_balance = @balance + amount
		raise "The maximum balance you can have is £#{MAXIMUM_LIMIT}!" if top_up_balance > MAXIMUM_LIMIT
		@balance += amount
	end

	def deduct(amount)
		@balance -= amount
	end

	def touch_in
		raise 'Please top up more than £1!' if @balance < MINIMUM_AMOUNT
		@in_journey = true
	end

	def touch_out
		@in_journey = false
	end

	def in_journey?
		@in_journey
	end

end

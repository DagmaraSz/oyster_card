class Oystercard

	MAXIMUM_LIMIT = 90
	MINIMUM_AMOUNT = 1

	attr_reader :balance, :journey_history, :journey

	def initialize(balance = 0)
		@balance = balance
		@journey_history = []
	end

	def top_up(amount)
		raise "The maximum balance you can have is £#{MAXIMUM_LIMIT}!" if @balance + amount > MAXIMUM_LIMIT
		@balance += amount
	end

	def touch_in(station)
    process_journey if !@journey.nil? && @journey.exit_station.nil?
		raise 'Please top up more than £1!' if @balance < MINIMUM_AMOUNT
		create_journey(station)
	end

	def touch_out(station)
		create_journey if @journey.nil?
		@journey.finish(station)
    process_journey
	end

	private

	def deduct(amount)
		@balance -= amount
	end

  def process_journey
    deduct(@journey.calculate_fare)
		@journey_history << @journey
  end

  def create_journey(station =nil)
    @journey = Journey.new
		@journey.start(station)
  end


end

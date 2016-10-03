class Oystercard
  attr_reader :balance
  CAPACITY = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(value)
    raise "Limit of £#{CAPACITY} exceeded" if value + @balance > CAPACITY
    @balance += value
  end

  def in_journey?
    @in_journey
  end

  def touch_in
    raise "insufficient funds to complete journey" if @balance < MINIMUM_FARE
    @in_journey = true
  end

  def touch_out
    deduct(MINIMUM_FARE)
    @in_journey = false
  end

  private

  def deduct(value)
    @balance -= value
  end

end

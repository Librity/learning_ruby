# https://repl.it/@marzann/ruby-bank-account
class BankAccount
  attr_reader :balance

  def initialize(balance)
    @balance = balance
  end

  def deposit(amount)
    @balance += amount if amount >= 0
  end

  def withdraw(amount)
    @balance -= amount if @balance >= amount
  end
end

class SavingsAccount < BankAccount
  attr_reader :number_of_withdrawals
  APY = 0.0017

  def initialize(balance)
    super(balance) # calls the parent method
    @number_of_withdrawals = 0 # then continues here
  end

  def end_of_month_closeout
    if @balance > 0
      interest_gained = (@balance * APY) / 12
      @balance += interest_gained
    end
    @number_of_withdrawals = 0
  end
end

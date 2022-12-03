# https://repl.it/@aliyar/BLOC-Bank-Account-RUBY-class
class BankAccount
  # attr_accessor :balance, :number_of_withdrawals
  attr_reader :balance

  def initialize(balance)
    @balance = balance
  end

  # this method is not necessary, bc/ attr_reader on line 2.
  # def display_balance
  #   @balance
  # end

  def deposit(amount)
    @balance += amount if amount > 0
  end

  def withdraw(amount)
    @balance -= amount if amount <= @balance
    # @number_of_withdrawals += 1
  end
end

class CheckingAccount < BankAccount
  attr_reader :number_of_withdrawals
  MAX_FREE_WITHDRAWALS = 3 # these are always true
  WITHDRAWAL_FEE = 5 # these are always true

  def initialize(balance)
    super(balance)
    @number_of_withdrawals = 0
  end

  # again, not necessary b/c of attr_reader on line 26.
  # def show_withdrawals
  # @number_of_withdrawals
  # end

  def get_free_withdrawal_limit
    MAX_FREE_WITHDRAWALS
  end

  def transfer(account, amount)
    if account.balance >= amount
      deposit(amount)
      account.withdraw(amount)
    end
  end

  def withdraw(amount)
    super(amount)
    @number_of_withdrawals += 1
    @balance -= WITHDRAWAL_FEE if number_of_withdrawals > 3
    if @balance < 0
      deposit(amount)
      deposit(WITHDRAWAL_FEE)
    end
  end
end

# def transfer(account, amount)
# p account.get_free_withdrawal_limit
# p account.display_balance
# p amount
# if @number_of_withdrawals <= account.get_free_withdrawal_limit && account.display_balance >= amount
#   account.withdraw(amount)
#   p @number_of_withdrawals
#   self.deposit(amount)
# else
#   self.balance #70
#   fee = 5
#   amount = amount + fee
#   if (account.balance >= amount)
#     account.withdraw(amount)
#     p @number_of_withdrawals
#     amount = amount - fee
#     self.deposit(amount)
#     self.balance
#   end
# end
#   end
# end

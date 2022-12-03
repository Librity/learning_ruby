# Allows user to manage their balance, and withdraw up to their credit
class BankAccount
  attr_reader :id, :owner, :document, :pin, :balance, :credit

  def initialize(id, owner, document, pin)
    @id = id
    @owner = owner
    @document = document
    @pin = valid_pin?(pin)
    @balance = 0
    @credit = 100
  end

  def deposit(amount)
    raise 'Deposit must be larger than zero.' if amount <= 0
    @balance += amount
  end

  def withdraw(amount)
    credit_limit = "$#{@credit} Credit limit exceeded! Balance: $#{@balance}"
    raise credit_limit if amount > @balance + @credit
    @balance -= amount
  end

  private

  def valid_pin?(pin)
    return invalid_pin! if pin.length != 4 && Integer(pin)
    pin.to_i
  end

  def invalid_pin!
    raise 'Pin must be a 4-digit integer.'
  end
end

# CLI for the bank's Autmatic Teller Machines
class ATM
  def initialize(account)
    @account = account
  end

  def access
    puts "Welcome to our banking system, #{@account.owner}!"
    check_pin! ? menu : pin_error
  end

  private

  def check_pin!
    print 'To access your account, please input your PIN: '
    @input_pin = gets.chomp.to_i
    @input_pin == @account.pin
  end

  def pin_error
    puts 'Access denied! Incorrect PIN.'
  end

  def menu
    puts 'Input s: to show balance, d: to deposit money or w: to withdraw money'
    action = gets.chomp.downcase
    options(action)
  end

  def options(action)
    case action
    when 's'
      display_balance
    when 'd'
      initiate_deposit
    when 'w'
      initiate_withdraw
    else
      menu
    end
  end

  def display_balance
    puts "Balance: $#{@account.balance}."
    menu
  end

  def initiate_deposit
    input_amount!
    @account.deposit(@money)
    puts "Deposited: $#{@money}. New balance: $#{@account.balance}."
    menu
  rescue StandardError => e
    puts e.message
    menu
  end

  def initiate_withdraw
    input_amount!
    @account.withdraw(@money)
    puts "Withdrew: $#{@money}. New balance: $#{@account.balance}."
    menu
  rescue StandardError => e
    puts e.message
    menu
  end

  def input_amount!
    puts 'Input the amount'
    @money = gets.to_i
  end
end

my_account = BankAccount.new(1, 'Lusito', 'fakessn', '4576')
ATM.new(my_account).access

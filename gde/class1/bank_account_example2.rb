# https://codereview.stackexchange.com/questions/162405/ruby-banking-system-program
class Account
  attr_reader :name, :balance, :pin

  def initialize(name, pin, balance = 100)
    @name = name
    @pin = pin
    @balance = balance
  end

  def atm_access
    check_pin! ? atm_menu : pin_error
  end

  def atm_menu
    puts 'Input d: to deposit money, s: to show balance or w: to withdraw money'
    action = gets.chomp.downcase
    atm_options(action)
  end

  def atm_options(action)
    case action
    when 'd'
      deposit
    when 's'
      display_balance
    when 'w'
      withdraw
    else
      puts 'Try again'
    end
  end

  def input_amount
    puts 'Input the amount'
    @money = gets.to_i
  end

  def over_error
    puts "You don't own that kind of money, dude! Your balance: $#{@balance}"
  end

  def deposit
    @balance += input_amount
    puts "Deposited: $#{@money}. Updated balance: $#{@balance}."
  end

  def display_balance
    puts "Balance: $#{@balance}."
  end

  def withdraw
    amt = input_amount
    if  amt <= @balance
      @balance -= amt
      puts "Withdrew: $#{amt}. Updated balance: $#{@balance}."
    else
      over_error
    end
  end

  private

  def check_pin!
    puts "Welcome to the banking system, #{@name}!\n" + 'To access your account, input PIN please'
    @input_pin = gets.chomp.to_i
    @input_pin == @pin
  end

  def pin_error
    puts 'Access denied: incorrect PIN.'
  end
end

checking_account = Account.new('James Bond', 4576, 520_000)
checking_account.access

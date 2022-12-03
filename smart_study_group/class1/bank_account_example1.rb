# https://github.com/angeltejon/Ruby-Bank-Account-PROGRAM/blob/master/class%20Account
class Account
  attr_reader :name, :balance
  def initialize(name, balance = 100)
    @name = name
    @balance = balance
  end

  private

  def pin
    @pin = 1234
  end

  def pin_error
    'Access denied: incorrect PIN.'
  end

  def new_pin(pin_number)
    @pin_broker = pin_broker
    if pin_number == pin
      print 'please, introduce your new pin number: '
      new_pin_number = Integer(gets.chomp)
      if new_pin_number.length == 4
        @pin == new_pin_number
        puts "You've changed your pin number to #{@pin}."
      else
        puts 'try again!! your pin number must have exactly FOUR characters!'
      end
    else
      puts pin_error
    end
  end

  public

  def display_balance(pin_number)
    if pin_number == pin
      puts "#{@name}, your Balance is: $#{@balance}."
    else
      puts pin_error
    end
  end

  def withdraw(pin_number, amount)
    if pin_number == pin
      @balance -= amount
      puts "Withdrew #{amount}. New balance: $#{@balance}."
    else
      puts pin_error
    end
  end

  def deposit(pin_number, amount)
    if pin_number == pin
      @balance += amount
      puts "Deposit #{amount}. New Balance: $#{@balance}."
    else
      puts pin_error
    end
  end
end

checking_account = Account.new('Emilio_Botin', 1_000_000_000)
urban_guy = Account.new('El_Cholas', 1_200)
rural_man = Account.new('Pepito', 4_330)
folder_woman = Account.new('Janira', 18_000)

checking_account.display_balance(1234)
urban_guy.display_balance(1234)
rural_man.display_balance(1234)
folder_woman.display_balance(1234)

pin_broker.new_pin(1234)

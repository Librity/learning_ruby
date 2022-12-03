# https://stackoverflow.com/questions/26601700/simple-bank-class-in-ruby-breaking
class Person
  attr_accessor :name, :initAmount

  def initialize(name, initAmount = 0)
    @name = name
    @initAmount = initAmount
    puts "Hi, #{name}.  You have $#{initAmount} on hand!"
  end
end

class Bank
  def initialize(bank_name, balance = 0, deposit = 0)
    @bankName = bank_name
    @balance = balance
    @deposit = deposit
    puts "#{bank_name} bank was just created."
  end

  def open_account(person)
    @balance = person.initAmount
    puts "#{person.name}, thanks for opening an account at #{@bankName}!"
  end

  def withdrawal(name, amount)
    if amount > 0
      @balance -= amount
      puts "#{name} withdrew $#{amount} from #{@bankName}.  #{name} has #{@balance}.  #{name}'s account has #{@balance}."
    end
  end

  def deposit(name, amount)
    if amount > 0
      @balance += amount
      puts "#{name} deposited $#{amount} to #{@bankName}. #{name} has #{@balance}. #{name}'s account has #{@balance}."
    end
  end

  def transfer(name, _bankName, amount)
    if @name = name
      @balance -= amount
      puts "#{name} have transfered $#{amount} from #{@bankName} account to #{@bankName}.  Your new balance is $#{@balance}."
    else
      puts 'Wrong username'
    end
  end
end

chase = Bank.new('JP Morgan Chase')
wells_fargo = Bank.new('Wells Fargo')
me = Person.new('Tom', 500)
friend1 = Person.new('hon', 1000)
chase.open_account(me)
chase.open_account(friend1)
wells_fargo.open_account(me)
wells_fargo.open_account(friend1)
chase.deposit(me, 200)
chase.deposit(friend1, 300)
chase.withdraw(me, 50)
chase.transfer(me, wells_fargo, 100)
# chase.deposit(me, 5000)
# chase.withdraw(me, 5000)
# puts chase.total_cash_in_bank
# puts wells_fargo.total_cash_in_bank

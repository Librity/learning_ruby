# https://rubygarage.org/blog/solid-principles-of-ood
# Single Responsibility

# Bad example:
# Violation of the Single Responsibility Principle in Ruby
class FinancialReportMailer
  def initialize(transactions, account)
    @transactions = transactions
    @account = account
    @report = ''
  end

  def generate_report!
    @report = @transactions.map {
      |t| "amount: #{t.amount} type: #{t.type} date: #{t.created_at}"
    }.join("\n")
  end

  def send_report
    Mailer.deliver(
      from: 'reporter@example.com',
      to: @account.email,
      subject: 'your report',
      body: @report
    )
  end
end

mailer = FinancialReportMailer.new(transactions, account)
mailer.generate_report!
mailer.send_report

# Good example:
class FinancialReportMailer
  def initialize(report, account)
    @report = report
    @account = account
  end

  def deliver
    Mailer.deliver(
      from: 'reporter@example.com',
      to: @account.email,
      subject: 'Financial report',
      body: @report
    )
  end
end

class FinancialReportGenerator
  def initialize(transactions)
    @transactions = transactions
  end

  def generate
    @transactions.map { |t| "amount: #{t.amount} type: #{t.type} date: #{t.created_at}"
    }.join("\n")
  end
end

report = FinancialReportGenerator.new(transactions).generate
FinancialReportMailer.new(report, account).deliver

################################################################################
# Open/Closed
# Bad example:
# Violation of the Open-Closed Principle in Ruby
class Logger
  def initialize(format, delivery)
    @format = format
    @delivery = delivery
  end

  def log(string)
    deliver format(string)
  end

  private

  def format(string)
    case @format
    when :raw
      string
    when :with_date
      "#{Time.now} #{string}"
    when :with_date_and_details
      "Log was creates at #{Time.now}, please check details #{string}"
    else
      raise NotImplementedError
    end
  end

  def deliver(text)
    case @delivery
    when :by_email
      Mailer.deliver(
        from: 'emergency@example.com',
        to: 'admin@example.com',
        subject: 'Logger report',
        body: text
      )
    when :by_sms
      client = Twilio::REST::Client.new('ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', 'your_auth_token')
      client.account.messages.create(
        from: '+15017250604',
        to: '+15558675309',
        body: text
      )
    when :to_stdout
      STDOUT.write(text)
    else
      raise NotImplementedError
    end
  end
end

logger = Logger.new(:raw, :by_sms)
logger.log('Emergency error! Please fix me!')

# Good example:
# Correct use of the Open-Closed Principle in Ruby
class Logger
  def initialize(formatter: DateDetailsFormatter.new, sender: LogWriter.new)
    @formatter = formatter
    @sender = sender
  end

  def log(string)
    @sender.deliver @formatter.format(string)
  end
end

class LogSms
  def initialize
    @account_sid = 'ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    @auth_token = 'your_auth_token'
    @from = '+15017250604'
    @to = '+15558675309'
  end

  def deliver(text)
    client.account.messages.create(from: @from, to: @to, body: text)
  end

  private

  def client
    @client ||= Twilio::REST::Client.new(@account_sid, @auth_token)
  end
end

class LogMailer
  def initialize
    @from = 'emergency@example.com'
    @to = 'admin@example.com'
    @sublect = 'Logger report'
  end

  def deliver(text)
    Mailer.deliver(
      from: @from,
      to: @to,
      subject: @sublect,
      body: text
    )
  end
end

class LogWriter
  def deliver(log)
    STDOUT.write(text)
  end
end

class DateFormatter
  def format(string)
    "#{Time.now} #{string}"
  end
end

class DateDetailsFormatter
  def format(string)
    "Log was creates at #{Time.now}, please check details #{string}"
  end
end

class RawFormatter
  def format(string)
    string
  end
end

logger = Logger.new(formatter: RawFormatter.new, sender: LogSms.new)
logger.log('Emergency error! Please fix me!')

################################################################################
# Liskov Substitution
# Bad example:
# Violation of the Liskov Substitution Principle in Ruby
class UserStatistic
  def initialize(user)
    @user = user
  end

  def posts
    @user.blog.posts
  end
end

class AdminStatistic < UserStatistic
  def posts
    user_posts = super

    string = ''
    user_posts.each do |post|
      string += "title: #{post.title} author: #{post.author}\n" if post.popular?
    end

    string
  end
end

# Good example:
# Correct use of the Liskov Substitution Principle in Ruby
class UserStatistic
  def initialize(user)
    @user = user
  end

  def posts
    @user.blog.posts
  end
end

class AdminStatistic < UserStatistic
  def posts
    user_posts = super
    user_posts.select { |post| post.popular? }
  end

  def formatted_posts
    posts.map { |post| "title: #{post.title} author: #{post.author}" }.join("\n")
  end
end

################################################################################
# Interface Segregation
# Bad example:
# Violation of the Interface Segregation Principle in Ruby
class CoffeeMachineInterface
  def select_drink_type
      # select drink type logic
  end

  def select_portion
     # select portion logic
  end

  def select_sugar_amount
     # select sugar logic
  end

  def brew_coffee
     # brew coffee logic
  end

  def clean_coffee_machine
    # clean coffee machine logic
  end

  def fill_coffee_beans
    # fill coffee beans logic
  end

  def fill_water_supply
    # fill water logic
  end

  def fill_sugar_supply
    # fill sugar logic
  end
end

class Person
  def initialize
    @coffee_machine = CoffeeMachineInterface.new
  end

  def make_coffee
    @coffee_machine.select_drink_type
    @coffee_machine.select_portion
    @coffee_machine.select_sugar_amount
    @coffee_machine.brew_coffee
  end
end

class Staff
  def initialize
    @coffee_machine = CoffeeMachineInterface.new
  end

  def serv
    @coffee_machine.clean_coffee_machine
    @coffee_machine.fill_coffee_beans
    @coffee_machine.fill_water_supply
    @coffee_machine.fill_sugar_supply
  end
end

# Good example:
# Correct use of the Interface Segregation Principle in Ruby
class CoffeeMachineUserInterface
  def select_drink_type
      # select drink type logic
  end

  def select_portion
     # select portion logic
  end

  def select_sugar_amount
     # select sugar logic
  end

  def brew_coffee
     # brew coffee logic
  end
end

class CoffeeMachineServiceInterface
  def clean_coffee_machine
    # clean coffee machine logic
  end

  def fill_coffee_beans
    # fill coffee beans logic
  end

  def fill_water_supply
    # fill water logic
  end

  def fill_sugar_supply
    # fill sugar logic
  end
end

class Person
  def initialize
    @coffee_machine = CoffeeMachineUserInterface.new
  end

  def make_coffee
    @coffee_machine.select_drink_type
    @coffee_machine.select_portion
    @coffee_machine.select_sugar_amount
    @coffee_machine.brew_coffee
  end
end

class Staff
  def initialize
    @coffee_machine = CoffeeMachineServiceInterface.new
  end

  def serv
    @coffee_machine.clean_coffee_machine
    @coffee_machine.fill_coffee_beans
    @coffee_machine.fill_water_supply
    @coffee_machine.fill_sugar_supply
  end
end

################################################################################
# Dependency Inversion
# Bad example:
# Violation of the Dependency Inversion Principle in Ruby
class Printer
  def initialize(data)
    @data = data
  end

  def print_pdf
    PdfFormatter.new.format(@data)
  end

  def print_html
    HtmlFormatter.new.format(@data)
  end
end

class PdfFormatter
  def format(data)
    # format data to Pdf logic
  end
end

class HtmlFormatter
  def format(data)
    # format data to Html logic
  end
end

# Good example:
#Correct use of the Dependency Inversion Principle in Ruby
class Printer
  def initialize(data)
    @data = data
  end

  def print(formatter: PdfFormatter.new)
    formatter.format(@data)
  end
end

class PdfFormatter
  def format(data)
    # format data to Pdf logic
  end
end

class HtmlFormatter
  def format(data)
    # format data to Html logic
  end
end
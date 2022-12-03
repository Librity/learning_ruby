# https://medium.com/rubycademy/solid-ruby-in-5-short-examples-353ea22f9b05
# Single Responsibility: change only one aspect, change only one class.
class Logger
  def log(message)
    puts message
  end
end

class Authenticator
  def initialize
    @logger = Logger.new
  end

  def sign_in(profile)
    @logger.log("user #{profile.email}: signed in at <#{profile.signed_in_at}>")
  end
end

################################################################################
# Open/Closed: Inheriting a class > Modifying a class.
class Collection < Array
  def print_collection
    # ...
  end

  def [](position)
    # ...
  end
end
################################################################################
# Liskov Substitution: child behaves like parent.
class Role
  def to_s
    'default'
  end
end

class Admin < Role
  def to_s
    'admin'
  end
end

class User < Role
  def to_s
    'user'
  end
end

class RoleLogger
  def print_role(role)
    p "role: #{role}"
  end
end

logger = RoleLogger.new
logger.print_role(Role.new)  # => "role: default"
logger.print_role(Admin.new) # => "role: admin"
logger.print_role(User.new)  # => "role: user"
################################################################################
# https://drive.google.com/file/d/0BwhCYaYDn8EgOTViYjJhYzMtMzYxMC00MzFjLWJjMzYtOGJiMDc5N2JkYmJi/view
# Interface Segregation

################################################################################
# https://web.archive.org/web/20110714224327/http://www.objectmentor.com/resources/articles/dip.pdf
# Dependency Inversion

# PS: Due to duck typing design, Interface Segregation and Dependency Inversion
# principle are not relevant in Ruby.

# https://thoughtbot.com/blog/back-to-basics-solid
# Single Responsibility

# Bad example:
class DealProcessor
  def initialize(deals)
    @deals = deals
  end

  def process
    @deals.each do |deal|
      Commission.create(deal: deal, amount: calculate_commission)
      mark_deal_processed
    end
  end

  private

  def mark_deal_processed
    @deal.processed = true
    @deal.save!
  end

  def calculate_commission
    @deal.dollar_amount * 0.05
  end
end

# Good example:
class DealProcessor
  def initialize(deals)
    @deals = deals
  end

  def process
    @deals.each do |deal|
      mark_deal_processed
      CommissionCalculator.new.create_commission(deal)
    end
  end

  private

  def mark_deal_processed
    @deal.processed = true
    @deal.save!
  end
end

class CommissionCalculator
  def create_commission(deal)
    Commission.create(deal: deal, amount: deal.dollar_amount * 0.05)
  end
end
################################################################################
# Open/Closed
# Bad example:
class UsageFileParser
  def initialize(client, usage_file)
    @client = client
    @usage_file = usage_file
  end

  def parse
    case @client.usage_file_format
    when :xml
      parse_xml
    when :csv
      parse_csv
    end

    @client.last_parse = Time.now
    @client.save!
  end

  private

  def parse_xml
    # parse xml
  end

  def parse_csv
    # parse csv
  end
end

# Good example:
class UsageFileParser
  def initialize(client, parser)
    @client = client
    @parser = parser
  end

  def parse(usage_file)
    parser.parse(usage_file)
    @client.last_parse = Time.now
    @client.save!
  end
end

class XmlParser
  def parse(usage_file)
    # parse xml
  end
end

class CsvParser
  def parse(usage_file)
    # parse csv
  end
end

################################################################################
# Liskov Substitution
# Bad example:
class Rectangle
  def set_height(height)
    @height = height
  end

  def set_width(width)
    @width = width
  end
end

class Square < Rectangle
  def set_height(height)
    super(height)
    @width = height
  end

  def set_width(width)
    super(width)
    @height = width
  end
end

# Good example:
class Rectangle
  def height(height)
    @height = height
  end

  def width(width)
    @width = width
  end
end

class Square < Rectangle
  def side(side)
    @height = @width = side
  end
end

################################################################################
# Interface Segregation
# Bad example:
class Test {
  let questions: [Question]
  init(testQuestions: [Question]) {
    questions = testQuestions
  }

  func answerQuestion(questionNumber: Int, choice: Int) {
    questions[questionNumber].answer(choice)
  }

  func gradeQuestion(questionNumber: Int, correct: Bool) {
    question[questionNumber].grade(correct)
  }
}

class User {
  func takeTest(test: Test) {
    for question in test.questions {
      test.answerQuestion(question.number, arc4random(4))
    }
  }
}

# Good example:
protocol QuestionAnswering {
  var questions: [Question] { get }
  func answerQuestion(questionNumber: Int, choice: Int)
}

class Test: QuestionAnswering {
  let questions: [Question]
  init(testQuestions: [Question]) {
    self.questions = testQuestions
  }

  func answerQuestion(questionNumber: Int, choice: Int) {
    questions[questionNumber].answer(choice)
  }

  func gradeQuestion(questionNumber: Int, correct: Bool) {
    question[questionNumber].grade(correct)
  }
}

class User {
  func takeTest(test: QuestionAnswering) {
    for question in test.questions {
      test.answerQuestion(question.number, arc4random(4))
    }
  }
}

################################################################################
# Dependency Inversion
# Bad example:

# Good example:
class UsageFileParser
  def initialize(client, parser)
    @client = client
    @parser = parser
  end

  def parse(usage_file)
    parser.parse(usage_file)
    @client.last_parse = Time.now
    @client.save!
  end
end

class XmlParser
  def parse(usage_file)
    # parse xml
  end
end

class CsvParser
  def parse(usage_file)
    # parse csv
  end
end

module CalculationsHelper
  def project_count(count)
    count.nil? ? 'calculating..' : count
  end
end

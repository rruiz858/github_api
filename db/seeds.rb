(1..2000).step(200) do |n|
  Calculation.create(min_range: n, max_range: ((n / 200.0).ceil * 200))
end

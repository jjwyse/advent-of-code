file = File.open('input.txt')
lines = file.readlines

###################
# Part 1
###################

# x, y point

def plot_points(line:)
  starting_point = {
    0 => [0],
  }
  current_x = 0
  current_y = 0

  line.reduce(starting_point) do |points, instruction|
    direction = instruction[0]
    num_of_moves = instruction[1..instruction.length].to_i

    (1..num_of_moves).each do |i|
      case direction
        when 'R'
          current_x += 1
        when 'L'
          current_x -= 1
        when 'U'
          current_y += 1
        when 'D'
          current_y -= 1
      end

      points[current_x] = [] if points[current_x].nil?
      points[current_x] << current_y if !points[current_x].include?(current_y)
    end

    points
  end
end

# Plot points
line_one_points = plot_points(line: lines[0].split(',').map(&:chomp))
line_two_points = plot_points(line: lines[1].split(',').map(&:chomp))

# Find intersections
manhattan_intersections = []
line_one_points.each do |x, ys|
  next if line_two_points[x].nil?

  ys.each do |y|
    manhattan_intersections << x.abs + y.abs if line_two_points[x].include?(y)
  end
end

pp manhattan_intersections.sort[1]

##################
# Part 2
###################

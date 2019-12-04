file = File.open('input.txt')
lines = file.readlines

# x, y point

def plot_points(line:)
  starting_point = {
    0 => {
      :ys => [0],
      0 => 0,
    },
  }
  step_counter = 0
  current_x = 0
  current_y = 0

  line.reduce(starting_point) do |points, instruction|
    direction = instruction[0]
    num_of_moves = instruction[1..instruction.length].to_i

    (1..num_of_moves).each do
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

      # Increment step counter and include when saving
      step_counter += 1

      # First time hitting this x-coordinate
      if points[current_x].nil?
        points[current_x] = {
          :ys => []
        }
      end

      if !points[current_x][:ys].include?(current_y)
        points[current_x][:ys] << current_y
        points[current_x][current_y] = step_counter
      end
    end

    points
  end
end

# Plot points
line_one_points = plot_points(line: lines[0].split(',').map(&:chomp))
line_two_points = plot_points(line: lines[1].split(',').map(&:chomp))

# Find intersections
manhattan_intersections = []
line_one_points.each do |x, line_one_metadata|
  next if line_two_points[x].nil?

  ys = line_one_metadata[:ys]

  ys.each do |y|
    line_two_metadata = line_two_points[x]
    if line_two_metadata[:ys].include?(y)
      manhattan_intersections << line_one_metadata[y] + line_two_metadata[y]
    end
  end
end

pp manhattan_intersections.sort[1]

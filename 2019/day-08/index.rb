password = File.open('input.txt').readlines.first.chomp

###################
# Part 1
###################
#
# Images are sent as a series of digits that each represent the color of a single pixel.
# The digits fill each row of the image left-to-right, then move downward to the next row,
# filling rows top-to-bottom until every pixel of the image is filled.
#

image_width = 25
image_height = 6

step_size = image_width * image_height
images = (0..password.length).step(step_size).map do |index|
  from = index
  to = index + step_size - 1
  p = password[from..to]
  next if p.nil? || p.empty?
  p
end.compact

winning_image = images
                  .each_with_index
                  .map { |image, index|
                    {
                      index: index,
                      zero_count: image.count('0')
                    }
                  }.min_by { |val| val[:zero_count] }

num_1s = images[winning_image[:index]].count('1')
num_2s = images[winning_image[:index]].count('2')
pp num_1s * num_2s

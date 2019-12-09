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
#pp num_1s * num_2s

###################
# Part 2
###################
#
# 0 is black
# 1 is white
# 2 is transparent

image_layer = images[0]
pixels = image_layer.split('').map(&:to_i)
final_image = pixels.each_with_index.map do |pixel, index|
  final_image_pixel = pixel

  # Found transparent image at this layer, so lets look at lower layers
  if pixel == 2
    # Find first 1 or 2 at this index in lower layers
    final_image_pixel = images
                          .map { |i|
                            i[index] if i[index] != '2'
                          }
                          .compact
                          .first
                          .to_i
  end

  final_image_pixel
end

pp final_image.each_slice(image_width).to_a

#!/usr/bin/env ruby

require 'digest/md5'
require 'exifr'
require 'fileutils'

$stdout = File.new('log.txt', 'w')

imagesDir = "images"
duplicates = "duplicates"

images = Array.new

# looping through the directory of images
Dir.glob(imagesDir + "/**/*.jpg") do |my_image_file|
  puts "processing #{my_image_file}"
  
  #hash the image
  hash = Digest::MD5.file my_image_file
  
  #check if it exists in the array already
  result = images.include? hash
  if result
      # file is a duplicate, lets move it to the duplicates folder
      puts "#{my_image_file} already exists - moving it to #{duplicates}"
      filename = my_image_file.split("/").last
      FileUtils.mv(my_image_file, duplicates + "/" + filename)
      else
      # file is not a duplicate, lets add to the array
      images.push(hash)
  end
end
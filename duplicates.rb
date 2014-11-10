#!/usr/bin/env ruby

require 'digest/md5'
require 'exifr'
require 'fileutils'

$stdout = File.new('log.txt', 'w')

imagesDir = "images/"
imagesToCheck = "check/"
duplicates = "duplicates/"

images = Array.new

# load contents of imagesDir into an array 
Dir.glob(imagesDir + "**/*.jpg") do |my_image_file|
  puts "adding #{my_image_file} to the array"
  hash = Digest::MD5.file my_image_file
  images.push(hash)
end

# loop through images in imagesToCheck and check if they already exist
Dir.glob(imagesToCheck + "**/*.jpg") do |my_image_file|
  puts "checking if #{my_image_file} already exists"
  hash = Digest::MD5.file my_image_file
  result = images.include? hash
  if result
    puts "it does already exist - moving the image"
    filename = my_image_file.split("/").last
    FileUtils.mv(my_image_file, duplicates + filename)
  else
    puts "image is not a duplicate"
  end
end
#!/usr/bin/env ruby

require 'digest/md5'
require 'exifr'
require 'fileutils'
require 'logger'

imagesDir = "images"
imagesToCheck = "check"
duplicates = "duplicates"

currentDateTime = Time.now.strftime("%Y%m%d-%H%M")


logger = Logger.new 'output_' + currentDateTime + '.log'
images = []

# load contents of imagesDir into an array 
Dir.glob(imagesDir + "/**/*.jpg") do |my_image_file|
  logger.info "adding #{my_image_file} to the array"
  hash = Digest::MD5.file my_image_file
  images << hash
end

# loop through images in imagesToCheck and check if they already exist
Dir.glob(imagesToCheck + "/**/*.jpg") do |my_image_file|
  logger.info "checking if #{my_image_file} already exists"
  hash = Digest::MD5.file my_image_file
  result = images.include? hash
  if result
    logger.info "image is a duplicate - moving it to " + duplicates
    filename = File.basename(my_image_file)
    newLocation = File.join(duplicates,filename)
    FileUtils.mv(my_image_file, newLocation)
  else
    logger.info "image is not a duplicate - leaving it where it is "
  end
end
#!/usr/bin/env ruby

require 'digest/md5'
require 'fileutils'
require 'logger'
require 'optparse'

now = Time.now.strftime("%Y%m%d-%H%M")
logger = Logger.new "output_#{now}.log"

images = []

options = {}
OptionParser.new do |opts|
    opts.banner = "Usage: duplicates.rb [options]"
    
    opts.on('-i', '--images FOLDER', 'Images folder - main folder of images') { |v| options[:images] = v }
    opts.on('-c', '--check FOLDER', 'Images to check - program will check if any images in this folder exists in the main image folder') { |v| options[:check] = v }
    opts.on('-d', '--duplicates FOLDER', 'Duplicates folder - duplicate images are moved to this destination') { |v| options[:duplicates] = v }
    
end.parse!

if options[:check]
    # load contents of imagesDir into an array
    Dir.glob(File.join(options[:images],"/**/*.jpg")) do |image_file|
        logger.info "processing #{image_file}"
        hash = Digest::MD5.file image_file
        images << hash
    end
    
    # loop through images in imagesToCheck and check if they already exist
    Dir.glob(File.join(options[:check],"/**/*.jpg")) do |image_file|
        logger.info "checking if #{image_file} already exists"
        hash = Digest::MD5.file image_file
        result = images.include? hash
        if result
            logger.info "image is a duplicate - moving it to #{options[:duplicates]}"
            filename = File.basename(image_file)
            new_location = File.join(options[:duplicates],filename)
            FileUtils.mv(image_file, new_location)
        else
            logger.info "image is not a duplicate - leaving it where it is"
        end
    end
else
    #looping through the directory of images
    Dir.glob(File.join(options[:images],"/**/*.jpg")) do |image_file|
        logger.info "processing #{image_file}"
    
        #hash the image
        hash = Digest::MD5.file image_file
    
        #check if it exists in the array already
        result = images.include? hash
        if result
            # file is a duplicate, lets move it to the duplicates folder
            logger.info "#{image_file} is a duplicate - moving it to #{options[:duplicates]}"
            filename = File.basename(image_file)
            new_location = File.join(options[:duplicates],filename)
            FileUtils.mv(image_file, new_location)
        else
            # file is not a duplicate, lets add to it the array
            images << hash
        end
    end
end




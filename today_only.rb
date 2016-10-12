#!/usr/bin/env ruby
# encoding: utf-8

require 'open-uri'
require 'json'

class Time
  def today?
    time = Time.now
    today_start = Time.new(time.year,time.month,time.day)
    today_end = today_start + 86399
    (today_start..today_end).cover?(self)
  end
end

cache = "#{File.expand_path(File.dirname(__FILE__))}/cache"

if File.mtime(cache).today?
  json = File.read(cache)
else
  json = URI.parse('http://eldorado.ru/today_only').read.encode('utf-8')[/dataLayer\ = \[(.*)\]/, 1]
  File.write(cache, json)
end

product = JSON.parse(json)
old_price, new_price = product['productPriceOldLocal'].to_i, product['productPriceLocal'].to_i
discount = ((old_price - new_price) * 100 / old_price).round

puts case ARGV[0]
when '-n'
  product['productName']
when '-p'
  new_price
when '-o'
  old_price
when '-d'
  discount
else
  'use with argument -n/-p/-o/-d'
end

#!/usr/bin/env ruby
require 'rbkb' #needed for hexify method

cryptedfile = File.open('classification_guide_utf32le.enc')
cryptedfile = cryptedfile.read
plaintextfile = File.open('classification_guide_utf32le.txt')
plaintextfile = plaintextfile.read

#it's 16 chars instead of 8 because you hexify it first and each byte is 2 instead of 1
array1 = cryptedfile.hexify.scan(/.{16}/) 
array2 = plaintextfile.hexify.scan(/.{16}/)

#zip the two arrays into a hash for key,value lookups
lookup = Hash[array1.zip(array2)]

otherencrypted = File.open('hillary.eml.enc')
otherencrypted = otherencrypted.read
array3 = otherencrypted.hexify.scan(/.{16}/)


#for every 8 byte chunk in the 2nd encrypted email
#if that chunk exists in the lookup, output the corresponding plaintext
#otherwise output "." in utf32 (maybe not needed, i dunno). '.' represents an undecrypted ciphertext
array3.each do |x|
    if lookup[x].nil?
      print "\x2e\x00\x00\x00"
    else
      print lookup[x].unhexify
    end
end

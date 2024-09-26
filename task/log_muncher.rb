require 'ffi'

module C
  extend FFI::Library

  ffi_lib './levenshtein.so'
  attach_function :levenshtein, [:string, :string], :int
end

def levenshtein_distance(first_word, second_word)
  return C::levenshtein(first_word, second_word)
end


names = Hash.new(0)
File.open('../data/log.txt').readlines.each do |line|
  index = line.index("=> ")
  name = line[index + 3 .. line.length - 2]
  names[name] += 1
end

votes = Hash[names.sort_by{|k,v| -v}[0..199]] 
for k,v in votes
  votes[k] = 0
end

iteration = 0
for name,name_count in names
  for k, v in votes
    if levenshtein_distance(name, k) <= 4
      votes[k] +=name_count
    end
  end
end

for k, v in votes.sort_by{|k,v| v}.reverse
  p k + v.to_s
end


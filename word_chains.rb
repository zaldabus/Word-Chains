class WordChain
  def initialize(source, target, dictionary = "dictionary.txt")
    @source, @target, @dictionary = source, target, dictionary
  end
  
  def run
    dictionary = File.readlines(@dictionary).map(&:chomp)
    
    parents = find_chain(@source, @target, dictionary)
    
    parents.nil? ? "Sorry, no word chain found." :     
    build_path_from_breadcrumbs(parents, @source, @target)
  end
  
  def adjacent_words(word, dictionary)
    adjacent_words = []
    
    word.each_char.with_index do |char, i|
      ("a".."z").each do |letter|
        next if char == letter
        
        new_word = word.dup
        new_word[i] = letter
        
        adjacent_words << new_word if dictionary.include?(new_word)
      end
    end
    adjacent_words
  end
  
  def explore_words(source)
    words_to_expand = [source]
    all_reachable_words = [source]
    
    dictionary = File.readlines(@dictionary).map(&:chomp)
    candidate_words = dictionary.select do |word| 
        word.length == source.length
    end
    
    until words_to_expand.empty?
      current_word = words_to_expand.shift
      adjacent_words(current_word, candidate_words).each do |word|
        candidate_words.delete(word)
        words_to_expand << word
        all_reachable_words << word
      end
    end
    all_reachable_words
  end
  
  def find_chain(source, target, dictionary)
    words_to_expand = [source]
    candidate_words = dictionary.select {|word| word.length == source.length}
    candidate_words.delete(source)
    parents = {}
    
    until words_to_expand.empty?
      parent_word = words_to_expand.shift

      adjacent_words(parent_word, candidate_words).each do |child_word|
        candidate_words.delete(child_word)
        words_to_expand << child_word
        parents[child_word] = parent_word
        return parents if child_word == target
      end
    end
    nil
  end
  
  def build_path_from_breadcrumbs(parents, source, target)
    path = [target]
    parent = target
    
    until parent == source
      parent = parents[parent]
      path << parent
    end
    
    path.reverse
  end
end

if __FILE__ == $PROGRAM_NAME
  source, target = ARGV[0], ARGV[1]
  puts WordChain.new(source, target).run
end
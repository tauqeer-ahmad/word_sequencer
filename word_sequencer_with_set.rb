class WordSequencerWithSet
  attr_accessor :dictionary_path, :output_directory, :dictionary
 
  def initialize(dictionary_path, output_directory)
    @dictionary_path = dictionary_path
    @output_directory = output_directory
    @dictionary = []
  end

  def process
    load_dictionary
    initialize_data
    generate_sequences_and_output
  end

  private

  def initialize_data
    sequences = Set.new
    words = Set.new
    to_remove = Set.new
  end

  def generate_sequences
    sequences = Set.new
    words = Set.new
    to_remove = Set.new

    dictionary.each do |word|
      letters = word.split(//)
      letters.each_cons(4) do |seq|
        seq = seq.join
        next if seq.scan(/[!@#$%^&*()_+{}\[\]:;'"\/\\?><.,0-9]/).empty?
        if !words.add?(seq)
          to_remove.add(seq)
        end
        sequences.add( {seq: seq, word: word} )
      end
    end
    sequences.delete_if { |hash| to_remove.include?(hash[:seq]) }
  end

  def generate_sequences_and_output
    sequences_file_path = "#{output_directory}/sequences.txt"
    words_file_path = "#{output_directory}/words.txt"

    File.delete(sequences_file_path) if File.exists?(sequences_file_path)
    File.delete(words_file_path) if File.exists?(words_file_path)

    output_sequences = File.open(sequences_file_path, 'w' )
    output_words = File.open(words_file_path, 'w' )

    generate_sequences.sort_by { |hash| hash[:seq] }.each do |hash|
      output_sequences.puts("#{hash[:seq]}")
      output_words.puts("#{hash[:word]}")
    end

    output_sequences.close
    output_words.close
  end

  def load_dictionary
    File.open(dictionary_path).each_line do |line|
      dictionary << line.chomp.downcase
    end
  end
end
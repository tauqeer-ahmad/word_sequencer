class WordSequencer
  attr_accessor :dictionary_path, :dictionary, :words, :sequences, :output_directory, :repeated_sequence
 
  def initialize(dictionary_path, output_directory)
    @dictionary_path = dictionary_path
    @output_directory = output_directory
    @dictionary = []
    @repeated_sequence = {}
    @sequences = {}
    @words = {}
  end

  def process
    load_dictionary
    initialize_data
    generate_sequences
    generate_output
  end

  private

  def initialize_data
    ('a'..'z').to_a.map do |alphabet|
      repeated_sequence[alphabet] = []
      sequences[alphabet] = []
      words[alphabet] = []
    end
  end

  def generate_sequences
    dictionary.each do |dictionary_word|
      letters = dictionary_word.split(//)
      letters.each_cons(4) do |seq|
        current_sequence = seq.join()
        if current_sequence.scan(/[!@#$%^&*()_+{}\[\]:;'"\/\\?><.,0-9]/).empty?
          repeated_alphabet = current_sequence.slice(0, 1)
          check_if_in_sequence(current_sequence, dictionary_word, repeated_alphabet) unless repeated_sequence[repeated_alphabet].include? current_sequence
        end
      end
    end    
  end

  def generate_output
    sequences_file_path = "#{output_directory}/sequences.txt"
    words_file_path = "#{output_directory}/words.txt"

    File.delete(sequences_file_path) if File.exists?(sequences_file_path)
    File.delete(words_file_path) if File.exists?(words_file_path)

    output_sequences = File.open(sequences_file_path, 'w' )
    output_words = File.open(words_file_path, 'w' )

    output_sequences.puts(@sequences.values.flatten.join("\n"))
    output_words.puts(@words.values.flatten.join("\n"))

    output_sequences.close
    output_words.close
  end

  def check_if_in_sequence(seq, dict_word, repeated_alphabet)
    downcased_seq = seq.downcase
    index = sequences[repeated_alphabet].map(&:downcase).find_index(seq.downcase)
    if index
      sequences[repeated_alphabet].slice!(index)
      words[repeated_alphabet].slice!(index)
      repeated_sequence[repeated_alphabet] << downcased_seq
    else
      sequences[repeated_alphabet] << seq
      words[repeated_alphabet] << dict_word
    end
  end

  def load_dictionary
    File.open(dictionary_path).each_line do |line|
      dictionary << line.chomp.downcase
    end
  end
end
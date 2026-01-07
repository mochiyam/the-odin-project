# Mathematical approach
# Doesn't require as much memory as caesar_dressing_cipher_otherway but kinda hard to read tbh...
def caesar_dressing_cipher(text, id)
  result = ""

  text.chars do |ch|
    ord_char = ch.ord

    # Handles A - Z
    if (ord_char >= 65 && ord_char <= 90)
      result << ((((ord_char + id) - 65) % 26) + 65).chr

    # Handles a - z
    elsif (ord_char >= 97 && ord_char <= 122)
      result << ((((ord_char + id) - 97) % 26) + 97).chr

    else
      result << ch
    end
  end

  return result
end

puts caesar_dressing_cipher("What a string!", 5)

# Array based approach
# Memory heavy since it stores arrays for both uppercase and lowercase alphabets
def caesar_dressing_cipher_otherway(text, id)
  result = ""
  alphabet_lowercase = ('a'..'z').to_a
  alphabet_uppercase = ('A'..'Z').to_a

  text.each_char do |char|
    if alphabet_lowercase.include?(char)
      idx = alphabet_lowercase.index(char).modulo(26)
      result << alphabet_lowercase[idx]

    elsif alphabet_uppercase.include?(char)
      idx = alphabet_uppercase.index(char).modulo(26)
      result << alphabet_uppercase[idx]

    else
      result << char
    end
  end
  return result
end

puts caesar_dressing_cipher_otherway("What a string!", 5)
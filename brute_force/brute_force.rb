require 'minitest/autorun'

def search(text, pattern)
  text.size.times do |n|
    skip = false
    pattern.size.times do |m|
      unless text[n + m] == pattern[m]
        skip = true
        break
      end
    end
    return n unless skip
  end

  nil
end

class SearchTest < Minitest::Test
  def test_search
    assert_equal 6,   search('AABABBABABCAB', 'ABABCA')
    assert_equal nil, search('AABABBABABCAB', 'ABABCZ')
    assert_equal 15,  search('ABC ABCDAB ABCDABCDABDE', 'ABCDABD')
    assert_equal nil, search('AABABBABCACAB', 'ABABCA')
  end
end

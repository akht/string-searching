require 'minitest/autorun'

def kmp_table(pattern)
  table = []
  table[0] = -1
  table[1] = 0

  i = 2
  j = 0

  while i < pattern.size
    if pattern[i - 1] == pattern[j]
      table[i] = j + 1
      i += 1
      j += 1
    elsif j > 0
      j = table[j]
    else
      table[i] = 0
      i += 1
    end
  end

  table
end

def kmp_search(text, pattern)
  m = 0
  i = 0
  table = kmp_table(pattern)

  while (m + i) < text.size
    if pattern[i] == text[m + i]
      i += 1
      if i == pattern.size
        return m
      end
    else
      m = m + i - table[i]
      if i > 0
        i = table[i]
      end
    end
  end

  nil
end


def create_table(pattern)
  table = []
  table = [0]

  j = 0
  (1...pattern.size).each do |i|
    if pattern[i] == pattern[j]
      j += 1
      table[i] = j
    else
      table[i] = j
      j = 0
    end
  end

  # puts "table = #{table}"
  table
end

# https://algoful.com/Archive/Algorithm/KMPSearch
# これバグってる
# kmp_search2('AABABBABCACAB', 'ABABCA')の時に誤検出する
def kmp_search2(target, pattern)
  # ずらし表
  table = create_table(pattern)

  i = 0 # target文字列の比較開始位置
  p = 0 # pattern文字列の比較開始位置
  while i < target.size && p < pattern.size
    if target[i] == pattern[p]
      # 文字が一致していれば次の文字の比較に進む
      i += 1
      p += 1
    elsif p == 0
      # 不一致だった場合、それがパターン先頭文字なら問答無用で次の文字の比較に進む
      i += 1
    else
      # 不一致だった場合、それがパターン文字列の途中なら、次の比較を再開する位置はずらし表をみて決める
      p = table[p]
    end
  end

  if p == pattern.size
    return i - p
  end

  nil
end

def table(pattern)
  i = 0
  j = 1
  memo = [0]
  while j < pattern.size
    if pattern[i] == pattern[j]
      memo[j] = memo[j - 1] + 1
      i += 1
      j += 1
    else
      memo[j] = 0
      i = 0
      j += 1
    end
  end

  memo
end

def search(text, pattern)
  i = 0
  j = 0
  memo = table(pattern)

  # 先頭に番兵を入れておく
  pattern = ' ' + pattern
  memo.unshift 0

  count = 0
  while j < pattern.size - 1 && i < text.size
    if text[i] == pattern[j + 1]
      # 一致する時はそれぞれのポインタを進める
      i += 1
      j += 1
    elsif j == 0
      # パターン文字列の先頭で不一致の場合は、テキスト文字列の次の文字へ進む
      i += 1
    else
      # パターン文字列の途中で不一致の場合は、ずらし表をみてパターン文字列のポインタを戻す
      j = memo[j]
    end
  end

  if j == pattern.size - 1
    return i - j
  end

  nil
end


class SearchTest < Minitest::Test
  def test_kmp_search
    assert_equal 6,   kmp_search('AABABBABABCAB', 'ABABCA')
    assert_equal nil, kmp_search('AABABBABABCAB', 'ABABCZ')
    assert_equal 15,  kmp_search('ABC ABCDAB ABCDABCDABDE', 'ABCDABD')
    assert_equal nil, kmp_search('AABABBABCACAB', 'ABABCA')
  end

  def test_kmp_search2
    assert_equal 6,   kmp_search2('AABABBABABCAB', 'ABABCA')
    assert_equal nil, kmp_search2('AABABBABABCAB', 'ABABCZ')
    assert_equal 15,  kmp_search2('ABC ABCDAB ABCDABCDABDE', 'ABCDABD')
    assert_equal nil, kmp_search2('AABABBABCACAB', 'ABABCA')
  end

  def test_search
    assert_equal 6,   search('AABABBABABCAB', 'ABABCA')
    assert_equal nil, search('AABABBABABCAB', 'ABABCZ')
    assert_equal 15,  search('ABC ABCDAB ABCDABCDABDE', 'ABCDABD')
    assert_equal nil, search('AABABBABCACAB', 'ABABCA')
  end
end

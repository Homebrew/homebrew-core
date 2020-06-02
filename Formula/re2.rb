class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-06-01.tar.gz"
  version "20200601"
  sha256 "fb8e0f4ed7a212e3420507f27933ef5a8c01aec70e5148c6a35313573269fae6"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "24de88e2c4a0ce890de51229d017c2d95920e60da5b156f52732ff1eae81340a" => :catalina
    sha256 "02ab50a96b2b1deac2a7175fb1974563c06c9fe38d824147de837dfd0add601e" => :mojave
    sha256 "265c167a79095a8902a9bc072e5765e6092780be07dc6d0ddc5f057198e1570c" => :high_sierra
  end

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lre2",
           "test.cpp", "-o", "test"
    system "./test"
  end
end

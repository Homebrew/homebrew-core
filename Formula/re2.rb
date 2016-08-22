class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2016-08-01.tar.gz"
  version "20160801"
  sha256 "7d0197f8da12da29220f8364c172785e26abb3210cd48264cc39c712fba8ee1a"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "917546580bed4d2f8e60531a93ddc3cd5001be66100ffe52c862a31d30b1067b" => :el_capitan
    sha256 "3b75d5e178a745d21e338e9ab54f373dc81f4c3a85bce08e8e6f47f0f259b94e" => :yosemite
    sha256 "091c858f09f468f04b964f5b8986a85c0e4eb2b0c458502e96382a81b330e0f7" => :mavericks
  end

  needs :cxx11

  # https://github.com/google/re2/issues/102
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70932
  fails_with :gcc => "6" do
    cause "error: field 'next_' has incomplete type 'std::atomic<re2::DFA::State*> []'"
  end

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    system "install_name_tool", "-id", "#{lib}/libre2.0.dylib", "#{lib}/libre2.0.0.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.dylib"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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

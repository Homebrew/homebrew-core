class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2016-08-01.tar.gz"
  version "20160801"
  sha256 "7d0197f8da12da29220f8364c172785e26abb3210cd48264cc39c712fba8ee1a"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "d8dcda697625fdb8f2c71aa60d7f37024158f7f5c7dc3f6a127f10f44d1b3968" => :el_capitan
    sha256 "72ff8f36352deca47d2b35011244b385e02326fa492581703815f0d7eefb5d65" => :yosemite
    sha256 "51aaca52a0dca8c8ce9127e6b21083f674538a47f65391f22aa63df30eafca23" => :mavericks
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

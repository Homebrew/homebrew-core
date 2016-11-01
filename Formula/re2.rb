class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2016-11-01.tar.gz"
  version "20161101"
  sha256 "01ee949f03e1c4057dc533cf139f967fb1b427015769d53b9ee07757631e9669"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "a405751dc11641db25ca535d5eb9bc6ceb2f31055ec3d0d7e9655a8ad0cb2634" => :sierra
    sha256 "d1435a3e4bf75166f2b68409fc77e003da29ab69cdf6395122bbbe4a0a3062df" => :el_capitan
    sha256 "a4b8fd1bbff22f1552f88eb7694ac89caf8ce60695e5f5452a9bd7131e6f3e0c" => :yosemite
  end

  needs :cxx11

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

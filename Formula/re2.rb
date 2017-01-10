class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2017-01-01.tar.gz"
  version "20170101"
  sha256 "e46019b4428942464bf65ba92f2fcd88739d1b05fe7c3787bc031a03a50a327a"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "d6496dda9b6e863b8b06d350033e8656f792231e7d7609971800eac194a59c4d" => :sierra
    sha256 "5424f029d19403a7f962051dd054299745070007eb37ba444acfb9e42a5dfd2e" => :el_capitan
    sha256 "d0cb83cf4f3ac26dc46ad3a3dd223de8c0da581b963bd36c1420494a14559ae3" => :yosemite
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

class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2017-12-01.tar.gz"
  version "20171201"
  sha256 "62797e7cd7cc959419710cd25b075b5f5b247da0e8214d47bf5af9b32128fb0d"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "679ee7f3ddef4bb91c5f31d3a5d5d813d1811fdd76751fdba159cb56c47106df" => :high_sierra
    sha256 "26d49ed98c230b7d907e46a7ed65a1d3a7a8ed9b2f5dbdd6db285957669ece8d" => :sierra
    sha256 "20c7fb6f22e96b6c7472ff2fed194872d82c831d180b64466bb47a763170ebf7" => :el_capitan
  end

  needs :cxx11

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.0.0.0.dylib", "#{lib}/libre2.0.dylib")
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.dylib"
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

class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2018-02-01.tar.gz"
  version "20180201"
  sha256 "c8ab833081c9766ef4e4d1e6397044ff3b20e42be109084b50d49c161f876184"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "3aaaba4cf90743849818298a2dd831d2a64b350d9a31bcb888c17d071b30db6b" => :high_sierra
    sha256 "d1cb01d0c5a8e53a9cd2ce8595af2b6ee9528f7f305c91e069153a020d44cc86" => :sierra
    sha256 "06cc788ba640a13a851b20505f4dd53bf44768683f64c1465ff99092a2213bef" => :el_capitan
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

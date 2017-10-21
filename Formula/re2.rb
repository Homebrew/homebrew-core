class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2017-08-01.tar.gz"
  version "20170801"
  sha256 "938723dc197125392698c5fcf41acb74877866ff140b81fd50b7314bf26f1636"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "6a9bceee39fdd8c25a0e08cc430c14fedfeb61691f737d337c8307de0cfbb712" => :high_sierra
    sha256 "a5e367b48b0e39f779af46261614851a5d64e799fbd7e98a23ea6a3a1ee1c1eb" => :sierra
    sha256 "acfd83f1fde8c71d9eea5b5b3fe04faa00541c58f3331aa8841680749485c9c3" => :el_capitan
    sha256 "7658df57f4ee5ab781b017ff3df629c3fad1dda84527376042299923c0b481b6" => :yosemite
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

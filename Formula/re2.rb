class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2017-05-01.tar.gz"
  version "20170501"
  sha256 "337dc0857b8f83b4fc3b78a334829945d7f35c3c6e2b06bd10a1dd4858dcf4a5"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "a1eb08844aaf07fdeb18e082bb001451834ea6d132b7f2f69b82ac3688bdcbb9" => :sierra
    sha256 "16f945dc9a30bb2d9bffb968214c9684e7f07706e81831c4ce45eb03bc4248dd" => :el_capitan
    sha256 "1249e6addaba728172729cbac3644983eb7fca2056f8214d1dccf34f1f97067a" => :yosemite
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

class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2017-05-01.tar.gz"
  version "20170501"
  sha256 "337dc0857b8f83b4fc3b78a334829945d7f35c3c6e2b06bd10a1dd4858dcf4a5"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "d88edd339a32fbef58f47a882ec40d9a28e585755f27dbd8a8b369c97ad4c836" => :sierra
    sha256 "6a419730af2255632c663de92b77323dc2df0b7d1d85b43e410366a9b1ddb8ce" => :el_capitan
    sha256 "05a1ecd25145cb71d21b8214bafef9f91e8f8fbadd453207c213c5cd9e676e0b" => :yosemite
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

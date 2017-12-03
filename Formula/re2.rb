class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2017-12-01.tar.gz"
  version "20171201"
  sha256 "62797e7cd7cc959419710cd25b075b5f5b247da0e8214d47bf5af9b32128fb0d"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "351bb71659eaaed50e951705fa481ee02db806e41f9a3be937d2c6fd77667352" => :high_sierra
    sha256 "e0c9c1f05187b620c0f0dd524e12f62a57d3d7709fc82f9c6902aad83a5e1695" => :sierra
    sha256 "eaf16c434786a4e90f9f8b768ee2f4e46a0e6282bcf52bb591aa7bb58b613c8a" => :el_capitan
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

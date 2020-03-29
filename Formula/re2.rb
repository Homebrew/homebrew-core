class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-03-03.tar.gz"
  version "20200303"
  sha256 "04ee2aaebaa5038554683329afc494e684c30f82f2a1e47eb62450e59338f84d"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "abb07cfb9def8d6f25a0d5694f0f23ba44b5b500f2d45d25d27515f62802c01b" => :catalina
    sha256 "92c4603fad274003e71699376b20a40c6e57c13f878774a894e28a9ef73295c1" => :mojave
    sha256 "58ac31c06c851bc5632c3a0703c0d41e55d8b015229cf03de09ee4a8701d92ef" => :high_sierra
  end

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.6.0.0.dylib", "#{lib}/libre2.0.dylib")
    lib.install_symlink "libre2.6.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.6.0.0.dylib" => "libre2.dylib"
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

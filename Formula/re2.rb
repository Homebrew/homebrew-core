class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2019-12-01.tar.gz"
  version "20191201"
  sha256 "7268e1b4254d9ffa5ccf010fee954150dbb788fd9705234442e7d9f0ee5a42d3"
  revision 1
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "08eb2896f304e147b44fc2b3ef9631277bc09bc2ac574e8d8d951e0349c4858b" => :catalina
    sha256 "a2ee78ca2958912612703f9d83627c8a3c1295644eb5020b9cab7b224ca7ad0a" => :mojave
    sha256 "c9792eff4daa45a3aec96e397a4ddc2ba850788a981d11a3098c53243dc443b8" => :high_sierra
  end

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

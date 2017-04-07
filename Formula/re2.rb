class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2017-04-01.tar.gz"
  version "20170401"
  sha256 "908b2152eea1a7c5eefe27131d322308a9c30ed62e1254824404a2ab92bb2992"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "bc6487dd4f5e87d1793dba1db2d30617037a952c766d18ddea17a259365c8b55" => :sierra
    sha256 "80fa6cc79821ecfcd29a30aeb3769d194163780cd92ec88c544bbf78c9c2fa5f" => :el_capitan
    sha256 "2c58668ce6e1a60687c2ae51bf26039fc99293e875cb2b81d721397e95718754" => :yosemite
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

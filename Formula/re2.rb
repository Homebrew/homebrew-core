class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2018-08-01.tar.gz"
  version "20180801"
  sha256 "7c995c91c12201e61738f35cf4d1362758894d674a1e71dd116cafb4d860b752"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "d1b4822d195d1e3322bef11023001ed62c0a33629ed99835c46e2078f4611c75" => :high_sierra
    sha256 "8356625830c702596ac5aa725b1255e4c3c7e2fcbce0dd65ee3e404640894f0f" => :sierra
    sha256 "4d355345c87bbe94eed026e5a43b402904c766b72b4eb151183f5f1235842c83" => :el_capitan
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

class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2018-03-01.tar.gz"
  version "20180301"
  sha256 "51dc7ee9d1a68ee0209672ac4bdff56766c56606dfcdd57aed022015c4784178"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "ab11f1ba1d591a8be5d22a3545dc2238cadbcc1461f8acbc8eda2902d8d2d50e" => :high_sierra
    sha256 "d8424f64060303197a70e927450e36917493a8bac0326700ab1900b783f0206e" => :sierra
    sha256 "20b350616911dcd89d6c54b2d4944b8878fa4d9123cf7b95d98a66c16519e702" => :el_capitan
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

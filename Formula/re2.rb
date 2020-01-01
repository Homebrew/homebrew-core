class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-01-01.tar.gz"
  version "20200101"
  sha256 "7509a34636b7dd2966f7a34440cee1153983fd61a4bf8f759a4f7781b9ceebaf"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "0c852cb4d55d672ce34333ef9446e710aa14906412bbe1dc4536d2f3ede3e404" => :catalina
    sha256 "06ccee1b64861c1ef08b4f5ee84827bd81daaa525b59c9135084f861b4a2ed3b" => :mojave
    sha256 "d2634d57c449aca834e3821bb1235b93d32e860eac182707b86d8798ea774653" => :high_sierra
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

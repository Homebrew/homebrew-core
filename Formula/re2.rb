class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2019-01-01.tar.gz"
  version "20190101"
  sha256 "bee07121ce72ce10ccacb84e49b29d091ca18d5d14d950ab7c4657a0903655db"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "ce2bda9edbe124644d977cc25dfa7672b9039b05e500ed4b0583de4621138c54" => :mojave
    sha256 "7962193156fa1acf325c9f8d0be12bfef9c6a4d7a408cd35a4eb17baed349a12" => :high_sierra
    sha256 "88640ac51671f67ae2898cd677d32581c2af799b02fd99ef3436cf958644ece9" => :sierra
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

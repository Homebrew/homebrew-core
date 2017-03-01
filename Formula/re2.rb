class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2017-03-01.tar.gz"
  version "20170301"
  sha256 "19db0b87bdc22e7e4c66af17f3170167a1b9cb9e32fd6b26189157f1336b73e8"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "d6496dda9b6e863b8b06d350033e8656f792231e7d7609971800eac194a59c4d" => :sierra
    sha256 "5424f029d19403a7f962051dd054299745070007eb37ba444acfb9e42a5dfd2e" => :el_capitan
    sha256 "d0cb83cf4f3ac26dc46ad3a3dd223de8c0da581b963bd36c1420494a14559ae3" => :yosemite
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

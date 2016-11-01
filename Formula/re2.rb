class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2016-11-01.tar.gz"
  version "20161101"
  sha256 "01ee949f03e1c4057dc533cf139f967fb1b427015769d53b9ee07757631e9669"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "4b469d3e200c96b9d859e72f31afa8bd5229b887b7c137d870562e300fb38fe9" => :sierra
    sha256 "e9d0e5bfb3747ddf0f3f1717eff1d6f6b83e459f7da666cfd3d9e31a8b8ed979" => :el_capitan
    sha256 "2eeff194ccda94bb7855fa01b9a8ffc2f8b2e45c8e1a7072b75887c8a11eee60" => :yosemite
  end

  needs :cxx11

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    system "install_name_tool", "-id", "#{lib}/libre2.0.dylib", "#{lib}/libre2.0.0.0.dylib"
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

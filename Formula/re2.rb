class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2018-02-01.tar.gz"
  version "20180201"
  sha256 "c8ab833081c9766ef4e4d1e6397044ff3b20e42be109084b50d49c161f876184"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "2509709630617e1bbd2af7be7f0596ea7eb9195e953c172d2149ed96b301fabf" => :high_sierra
    sha256 "c9658429a42fbe1581790c8d2c2619a9eabe3211344316589fb0187e99601e09" => :sierra
    sha256 "33e23a2b0f14ad42032c0c17ee5093b231cb8fb8c7f4314ea89c8be393f24bc4" => :el_capitan
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

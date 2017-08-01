class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2017-08-01.tar.gz"
  version "20170801"
  sha256 "938723dc197125392698c5fcf41acb74877866ff140b81fd50b7314bf26f1636"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "13ff3f99c3cb1cccc2329edd26c2fa5acb8907e0d54afb584a84a1459b237ea3" => :sierra
    sha256 "01d61b9a2309853508e84da8f38b54c2cdd917e648b19a82161f3bf188717278" => :el_capitan
    sha256 "239493d25d1b65a3bed144182465ccebe4405a8612612188ac45ff0a56b92443" => :yosemite
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

class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  head "https://github.com/google/re2.git"

  stable do
    url "https://github.com/google/re2/archive/2016-05-01.tar.gz"
    version "20160501"
    sha256 "d9d13f0ea4e1c6628b1cb85eeee284d4fdd4948da94b1f205096254927092e3d"
  end

  bottle do
    cellar :any
    sha256 "e1042bd0951be2c2651327269ffdf605c6cddff01162c266dac9663ee846940a" => :el_capitan
    sha256 "00abdcbad108a5dee607a6b34ccb97d970f6dc6fd53dd9680e0549945ef2fb9e" => :yosemite
    sha256 "941571b08e34921134c2fc15b5e855f7c2da5a882fd262766fa01dac988990f3" => :mavericks
  end

  def install
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
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lre2",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end

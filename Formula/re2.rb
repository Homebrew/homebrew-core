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
    sha256 "d0214015eb8156922e35c4459aeb9fd57d1ccd6dd5225990205ac2dbf9699601" => :el_capitan
    sha256 "344fecb734914ac0de689b7264fd5db060688bfcb7609bb7882159aadea14c20" => :yosemite
    sha256 "dd79b7ece31f576f7827ba5daa348d95bf4dc0952f2d8e4b59922756b78d2752" => :mavericks
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

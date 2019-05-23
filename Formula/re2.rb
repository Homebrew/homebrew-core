class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2019-04-01.tar.gz"
  version "20190401"
  sha256 "2ed94072145272012bb5b7054afcbe707447d49dcd79fd6d1689e6f3dc589def"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "4c584fc8ac04aca25bac4ac5dec7ac0694a9c21fc542a933c502e638745b7fff" => :mojave
    sha256 "b48b6c7c0cc8abe6d72f0670ce643a7adbcf75480098de3473df53b1dd0c3bb7" => :high_sierra
    sha256 "abe31367aad3aecb1e016e1f3a7d0d32706915aa966e9ccdb1128fed78cc4394" => :sierra
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

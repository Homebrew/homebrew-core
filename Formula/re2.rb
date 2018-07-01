class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2018-07-01.tar.gz"
  version "20180701"
  sha256 "803c7811146edeef8f91064de37c6f19136ff01a2a8cdb3230e940b2fd9f07fe"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "848dab9a0f20ad568a7811091bd3012d9c4088c1a19766f7efd13c2339091eaa" => :high_sierra
    sha256 "361d751e54a0ce71402d22d1c8eb1b12ead32576b08eef26dc3ead14c0a82296" => :sierra
    sha256 "b9a173228752cec85ae8e29276c6cc05c850ca4551a9b474a2c26fd4aa5f93e1" => :el_capitan
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

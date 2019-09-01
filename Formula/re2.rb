class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2019-09-01.tar.gz"
  version "20190901"
  sha256 "b0382aa7369f373a0148218f2df5a6afd6bfa884ce4da2dfb576b979989e615e"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "9761a6c2400632daf81b739f56bf130619644defa30b39e457c08e6399c3e826" => :mojave
    sha256 "5f2a7eee1fcb0a895248efa37e0c861d30a53f93e9e8ee7dd254c5f854aa412e" => :high_sierra
    sha256 "d0b45927307386877b316eed8c6df9a41cdbafad12e6025bdcc64508e97eba1c" => :sierra
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

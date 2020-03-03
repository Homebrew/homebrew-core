class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-03-03.tar.gz"
  version "20200303"
  sha256 "04ee2aaebaa5038554683329afc494e684c30f82f2a1e47eb62450e59338f84d"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "eebe26247a98e443c02f2b9cfddbbd5fd5e49435f005db530ba645baa86f6331" => :catalina
    sha256 "620e2e371b663ba08f8db374ab07152bd075b7cea1cd8a54dcf8f1552a4d6d67" => :mojave
    sha256 "ddd0f9c9099379cdcfb95917da515918e767eee56cce4b779d663ff8efc1c468" => :high_sierra
  end

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.6.0.0.dylib", "#{lib}/libre2.0.dylib")
    lib.install_symlink "libre2.6.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.6.0.0.dylib" => "libre2.dylib"
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

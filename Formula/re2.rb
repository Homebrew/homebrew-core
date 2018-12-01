class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2018-12-01.tar.gz"
  version "20181201"
  sha256 "715e01685719a4ed68a353ae48249612ef4a7464755c3ecccaceae91ebd34868"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "d366478de02ad27fde13652978894c4168598b1a63e7fb1d66c214ee0e247149" => :mojave
    sha256 "fbdc4cf54acf99d1712437b0ec6b96fe295c54a3265994dc75da12d72bdb5027" => :high_sierra
    sha256 "cbef8e8f1e0377e1ac0a379ff8c7a3408f7963aa1c37a94e219a86480da23737" => :sierra
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

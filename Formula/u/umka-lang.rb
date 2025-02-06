class UmkaLang < Formula
  desc "Statically typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "9ea56cc32e1556989b81cd3db5d0ae533ac3af708ec5c742c36628d6310b52c4"
  license "BSD-2-Clause"
  head "https://github.com/vtereshkov/umka-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e11927e3f524ea90873d145bd96ccfa4f8ed07c557289197d49622b94724c6db"
    sha256 cellar: :any,                 arm64_sonoma:  "d675847bcbbdf3eee73b4d1cf58545425c95a9e5af65cc774470d72acdc76feb"
    sha256 cellar: :any,                 arm64_ventura: "efe21ea65bc28aa268d765f3d1f97db53548f5d936eaed3589387340b9d5e073"
    sha256 cellar: :any,                 sonoma:        "9a75ffa1d9b4fbe9e1bfbe6b541f1f7dc0ad6de9ff26946ffe252dd27689c0af"
    sha256 cellar: :any,                 ventura:       "9f6e6d107a8b34d31ca053f21f13eb59ba9fccfac06ea25e52679ffa5c1f2429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74feb99912b383376a05160e5448396d60cb61427da89aed9acd1486f3eac528"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.um").write <<~UMKA
      fn main() {
        printf("Hello Umka!")
      }
    UMKA

    assert_match "Hello Umka!", shell_output("#{bin}/umka #{testpath}/hello.um")

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <umka_api.h>
      int main(void) {
          printf("Umka version: %s\\n", umkaGetVersion());
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lumka", "-o", "test"
    system "./test"
  end
end

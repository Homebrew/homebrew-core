class UmkaLang < Formula
  desc "Statically typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "b4dce5652a7e974e9ad63182f74b6033269b2d3ecad81b7d88f093816446e646"
  license "BSD-2-Clause"
  head "https://github.com/vtereshkov/umka-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9ffe7dadd236feba2e82c1f46bc6b6611fe763acd2b870025f14c2a01543793a"
    sha256 cellar: :any, arm64_sequoia: "d94f2d1e20ac0059aee234c228fafede9805cae32b06bd1055c56da7cae7f623"
    sha256 cellar: :any, arm64_sonoma:  "785d3f7b167b6c676f6e872a7806244283e39d879f5570ce51bd356cf10a673a"
    sha256 cellar: :any, sonoma:        "224453b1eb6959eb77c3e11cfc40582fbc03b459a758836b969690e413d1e28b"
    sha256 cellar: :any, arm64_linux:   "b2f01f3004b96eea9ad51fa1422024e9d5b26de6df0e307870bf8633940dd2a9"
    sha256 cellar: :any, x86_64_linux:  "44c64007151458d2943d83b9b9e1b65f38c5f521fd31efb89ad6b4895eab7cb6"
  end

  def install
    # Workaround to build on arm64 linux
    if OS.linux? && Hardware::CPU.arm?
      inreplace "Makefile" do |s|
        cflags = s.get_make_var("CFLAGS").split
        s.change_make_var! "CFLAGS", cflags.join(" ") if cflags.delete("-malign-double")
      end
    end

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

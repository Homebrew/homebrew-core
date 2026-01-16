class UmkaLang < Formula
  desc "Statically typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "b7673a445ee2ffbd161c89cb076452d8e04c4d842babf6c5bca963e52b75adfd"
  license "BSD-2-Clause"
  head "https://github.com/vtereshkov/umka-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71a5436d053b21e283fbb06d9af7e7759aa48e97595e75ee2a9988b057562bd4"
    sha256 cellar: :any,                 arm64_sequoia: "d817c9cbc87a0b2b11e9d4f99a191cb5b79e501a1c5f143deaf92e639d279f5d"
    sha256 cellar: :any,                 arm64_sonoma:  "410794c594fc46bbd6e6d462d778a72c0078670ac0783a7b2b6ffb719fff710a"
    sha256 cellar: :any,                 sonoma:        "67a296c502cdd51cde57976e7bb79096d6de79ca7ced79a938e07867925b4838"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "166e489ab4ebceca8e323def456813df04abcc2ebb9d2e5954399baa66884a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c75995cc4b4357d4df58387e9c25e310b599dfb7d9e4fa2ca38acc5a64213eee"
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

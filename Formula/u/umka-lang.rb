class UmkaLang < Formula
  desc "Statically typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "cf82ad85745339371172a0785fb44aeb60b7a78142ff55d6b3518d77abaa46ba"
  license "BSD-2-Clause"
  head "https://github.com/vtereshkov/umka-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ce9d7f8c1a9b3870eea9dda06784818398d87cb133578c3820ec6658effe167e"
    sha256 cellar: :any,                 arm64_sequoia: "5f0efe27433aed887a90e1845511bc3fa07034a1969afa4e2d33efffbb652cf1"
    sha256 cellar: :any,                 arm64_sonoma:  "4315a71b17be81a4c35247621cff8defe46dc9e52db97e31fa1e0e5b03f46437"
    sha256 cellar: :any,                 sonoma:        "c59889962ffef397dc393568a6faea797c6c3395169a33eef2261ba439aa784e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad9040267c97b992687c236fad2b5ec18cc10709302cca51abd1c0fca6c23695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd463f7849dcb9b7e59e59d2d81ea80e8dbdc272d3045f9e7b5c70dd84f61cd1"
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

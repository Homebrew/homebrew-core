class UmkaLang < Formula
  desc "Statically typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "b40ecaeafc4bcd2ed705868c183b0d40db344f28874933b67ee23d89dbe29518"
  license "BSD-2-Clause"
  head "https://github.com/vtereshkov/umka-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c45dad6f4dca2a4a4c00775b58f2b77ec2e050613bb44038f7a7491fd377352"
    sha256 cellar: :any,                 arm64_sequoia: "e0cf3861d1cc51ff4dc39e62f05b9fc7ae92417010b53910f32b4545894af83f"
    sha256 cellar: :any,                 arm64_sonoma:  "a35d9dc07073cef3ecf311f12cae7af924ee26ea7906a03958130035a4e0bef8"
    sha256 cellar: :any,                 arm64_ventura: "81df877bb4721e395076e831e938121f0b6c29c992b98f61119db0834b6883eb"
    sha256 cellar: :any,                 sonoma:        "9633dfef9c656af8c1f0b07f52215498751eaf08a334819e1b45217857963b28"
    sha256 cellar: :any,                 ventura:       "b131af9e493d3a5f5ad1ebe5c1ef13fab4a947a20c2caef15c6b5c088eb3d244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59990ebcb7e37a492d0c39d74ca4267992a6d1d636bf82cd9dc3e211fd7be0e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c838094302eeeefd555650800cdd39a50828c187759418e1b726ab9852e03be"
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

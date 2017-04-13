class Vc4asm < Formula
  desc "Macro assembler for Broadcom VideoCore IV aka Raspberry Pi GPU"
  homepage "http://maazl.de/project/vc4asm/doc/index.html"
  url "https://github.com/maazl/vc4asm/archive/V0.2.3.tar.gz"
  sha256 "8d5f49f7573d1cc6a7baf7cee5e1833af2a87427ad8176989083c6ba7d034c8c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b01a50db0867a9f940911026f4c18a2e91afd855cdef77e3835956cdf514cc6c" => :sierra
    sha256 "7dec394e660a8e8cb34f5e42b2e438c02bdf0cde94258f6acbd8d7d780af11a6" => :el_capitan
    sha256 "acd4fd9c7b398384be284256d6c7615687518b08c0a964146bbc4aefed27c794" => :yosemite
  end

  needs :cxx11

  # Fixes "ar: illegal option combination for -r"
  # Reported 13 Apr 2017 https://github.com/maazl/vc4asm/issues/18
  resource "old_makefile" do
    url "https://raw.githubusercontent.com/maazl/vc4asm/c6991f0/src/Makefile"
    sha256 "2ea9a9e660e85dace2e9b1c9be17a57c8a91e89259d477f9f63820aee102a2d3"
  end

  def install
    ENV.cxx11

    # Fixes "error: use of undeclared identifier 'errno'"
    # Reported 13 Apr 2017 https://github.com/maazl/vc4asm/issues/19
    inreplace "src/utils.cpp", "#include <unistd.h>",
                               "#include <unistd.h>\n#include <errno.h>"

    (buildpath/"src").install resource("old_makefile")
    system "make", "-C", "src"
    bin.install "bin/vc4asm", "bin/vc4dis"
    share.install "share/vc4.qinc"
  end

  test do
    (testpath/"test.qasm").write <<-EOS.undent
      mov -, sacq(9)
      add r0, r4, ra1.unpack8b
      add.unpack8ai r0, r4, ra1
      add r0, r4.8a, ra1
    EOS
    system "#{bin}/vc4asm", "-o test.hex", "-V", "#{share}/vc4.qinc", "test.qasm"
  end
end

class Vc4asm < Formula
  desc "Macro assembler for Broadcom VideoCore IV aka Raspberry Pi GPU"
  homepage "http://maazl.de/project/vc4asm/doc/index.html"
  url "https://github.com/maazl/vc4asm/archive/V0.2.2.tar.gz"
  sha256 "6f3da580aacecfd68219771d28ceddab987d26ca38eb4e38d8a93423e30eacb2"

  bottle do
    cellar :any_skip_relocation
    sha256 "b01a50db0867a9f940911026f4c18a2e91afd855cdef77e3835956cdf514cc6c" => :sierra
    sha256 "7dec394e660a8e8cb34f5e42b2e438c02bdf0cde94258f6acbd8d7d780af11a6" => :el_capitan
    sha256 "acd4fd9c7b398384be284256d6c7615687518b08c0a964146bbc4aefed27c794" => :yosemite
  end

  needs :cxx11

  def install
    ENV.cxx11

    # Fixes "use of undeclared identifier 'fabs'" and similar errors
    inreplace "src/AssembleInst.cpp", "#include <cstdlib>",
                                      "#include <cstdlib>\n#include <cmath>"

    cd "src" do
      system "make"
    end
    bin.install %w[bin/vc4asm bin/vc4dis]
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

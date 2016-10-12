class Vc4asm < Formula
  desc "Macro assembler for Broadcom VideoCore IV aka Raspberry Pi GPU"
  homepage "http://maazl.de/project/vc4asm/doc/index.html"
  url "https://github.com/maazl/vc4asm/archive/V0.2.2.tar.gz"
  sha256 "6f3da580aacecfd68219771d28ceddab987d26ca38eb4e38d8a93423e30eacb2"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bd42528fdebb2ae1b334f37fb36d0763b740692fc87e05000f03e82b4a953d2" => :sierra
    sha256 "d3e5bf0d350fe121f98dc5f9382a540246a35aa6ba329738ff6d328537521311" => :el_capitan
    sha256 "0f859510fcf092ac9aea3edf1a3bdca06fb33fbac058a6c6b07c4fe8485cf756" => :yosemite
    sha256 "17e23f6685049ca463e555f56947f2694fd14d45ac3e5be7cc82475cae251ca9" => :mavericks
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

class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.7.tar.gz"
  sha256 "5ddd8b9d57e91c798f464e83fa723cdbab45376958a56a554fbfb3c417844bfc"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "2ce2a2244da587f9c379d23ebc1e89e2a745d0181fe3509ddbc736a80983e31e" => :high_sierra
    sha256 "afdaa5acb9a6dcc53c998a8af7dd3f3470785161730f942aea33594a72b587f0" => :sierra
    sha256 "4bfc06c8aed435d19d7d9374783a32f2d692a22e30158387c126915eee09da1e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "make", "install", "PREFIX=#{prefix}", "mandir=#{man}"
  end

  test do
    (testpath/"source.asm").write <<~EOS
      SECTION "Org $100",HOME[$100]
      nop
      jp begin
      begin:
        ld sp, $ffff
        ld a, $1
        ld b, a
        add a, b
    EOS
    system "#{bin}/rgbasm", "source.asm"
  end
end

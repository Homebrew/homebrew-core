class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.4.tar.gz"
  sha256 "e65e4e1f6ad6ea7af96180a7b51d177bef348d09645ed3697de6bb6a71b56f1f"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8dd6338a07a6cc27e07da29b1b72876291bc60795d1ab2b08da2b97238270256" => :high_sierra
    sha256 "1fa2307cef60712c365ae15920753cc9c15d5c35e51149944b0a7631cb600aac" => :sierra
    sha256 "ff62fc8884337c780d57ae357150f138609b3f3e5f62915ae21694512673f493" => :el_capitan
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

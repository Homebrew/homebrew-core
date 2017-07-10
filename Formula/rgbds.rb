class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.2.tar.gz"
  sha256 "82a96be0ab18d847f189f79e932b10d6fd47213868cd8c282e3523395c01999b"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "4d5fdff77d984a24a9d82931e590121bd09edd9767d75be65f8ae4c24341ed14" => :sierra
    sha256 "d98f7943855a5fb1ee5a9e22412b4abcf2aed7b959fb13f9cc2fa56e20d2976c" => :el_capitan
    sha256 "b90d75440a16f5f08b2922b53a1015b14fbcf09b416f83d9e0ce3bf32efce81f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "make", "install", "PREFIX=#{prefix}", "mandir=#{man}"
  end

  test do
    (testpath/"source.asm").write <<-EOS.undent
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

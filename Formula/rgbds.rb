class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.5.tar.gz"
  sha256 "f1c5d986624573522b289d166d417a840b7d8fc311c1c4d5e97b1343b737b464"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "e4f9548f7c50d33d440eab94c645ce494db23f2acfaff2303b9d25d10405549e" => :high_sierra
    sha256 "e297588c977aa5331987fcd9ba5da4acaeba7c46f79343efdf2b35044c335d0e" => :sierra
    sha256 "eb8857e27143b03900eeb563764c279b531513f8bd6bf849eb5d1e1903f85ccb" => :el_capitan
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

class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.8.tar.gz"
  sha256 "fbf983cff2246b5169a66a61c182c3dd2b8d484bd683c5af94ede74ad983cc1f"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "63235bacb12f9daa1e3c081f98662f695d638c46ac3ac99565c29c28c8f5b9f6" => :mojave
    sha256 "75733389ad1941ad593f897c6a7279473c7dd1792499853a47434c638621adcd" => :high_sierra
    sha256 "cfd7aa69a25cbb7c2f140c5aae2b829bdd6ad6fd06cc489cdbab3a2d36fe0f96" => :sierra
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

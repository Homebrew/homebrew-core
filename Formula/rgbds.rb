class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.0.tar.gz"
  sha256 "00a8ac8cfaeaf5285fd24475a3d78053a35fd9599ab9493ca47dc41bcb6f7de0"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "32bd3ca1a387e01d23ccc2b621b700c3f45bf7626b9bef91613c722b023eb77d" => :sierra
    sha256 "9dbd994deb0e9f78e3bdaaefe4aa23b44b3a4cae1beddf87032f72ae006263ff" => :el_capitan
    sha256 "7f71d3c42a1bb7908401f8bc45d3cd7ec00c48d6423c42c8b7add48e866d753f" => :yosemite
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

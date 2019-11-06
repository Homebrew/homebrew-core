class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.8.tar.gz"
  sha256 "264f5e98ccdccb51b05dac80d9d37ddae769863c97f726b87be692edd5612256"
  revision 1
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "e6c072425e3776b171d8fd9643872aeba97654587730ff6879d30528327b3ee1" => :catalina
    sha256 "df3afb30c0abc0f2da49b139c38a48c17af9161632230160ef2492ed1847ad2d" => :mojave
    sha256 "81bb97ec05af2f438399076f49c8095a82c7345f6eb91058a7de9edbc4d35c36" => :high_sierra
    sha256 "b590e704362afe808cdf7ceab08cc2f4e479c6c14ce7ed0f3c4a9e403fee43f3" => :sierra
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

class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.4.0.tar.gz"
  sha256 "18be4a8ec79e43a6343fa128c6790dae33a229e0ed10e3dcccbbdc0b0c363933"
  license "MIT"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "471290b03b60ce630234ba35fedd6108e77a212e9a87cb81998a7c64c9eeac0e" => :catalina
    sha256 "23c50475699f8699d083f39bdfc9ca4b60c703f0c818ba22e8112d05b71a70ae" => :mojave
    sha256 "4c719b61b59c50d80cae21b6ea5bc8d47d54a653d4ecf403650efefa30927c8f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "make", "install", "PREFIX=#{prefix}", "mandir=#{man}"
  end

  test do
    # https://github.com/rednex/rgbds/blob/HEAD/test/asm/assert-const.asm
    (testpath/"source.asm").write <<~EOS
      SECTION "rgbasm passing asserts", ROM0[0]
        db 0
        assert @
    EOS
    system "#{bin}/rgbasm", "source.asm"
  end
end

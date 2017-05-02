class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.1.tar.gz"
  sha256 "3f58bc39fe9e90168d7618093160ce3caf9bdd3cfda311e92f618eb7ccba6f2d"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "a3bedd40aa36d2d1117d8fcd9c101161db73f125e70ef6fae4026fda049206c8" => :sierra
    sha256 "04e22d56594f10b991388ddcad4882ab3f62da8519f7806f32d988c050f2c27c" => :el_capitan
    sha256 "cebded8ba6cfa5470ce26c6eec742772e48eb3812f69484afa4591321d60225f" => :yosemite
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

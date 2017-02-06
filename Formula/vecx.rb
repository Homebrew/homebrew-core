class Vecx < Formula
  desc "Vectrex emulator"
  homepage "https://github.com/jhawthorn/vecx"
  url "https://github.com/jhawthorn/vecx/archive/v1.1.tar.gz"
  sha256 "206ab30db547b9c711438455917b5f1ee96ff87bd025ed8a4bd660f109c8b3fb"
  head "https://github.com/jhawthorn/vecx.git"

  bottle do
    cellar :any
    sha256 "fc2bccdd37c22fa9966690e5c61b967077de0d26fcc54ae965cc73119d2344e2" => :sierra
    sha256 "ea08d6c2a84382366688673dee326dee353a5e5e506d2f34ca673ce6964d3762" => :el_capitan
    sha256 "1d8d7c78396869a949aec225adbab7612812d4690cf3c96264609ba2a086a774" => :yosemite
  end

  depends_on "sdl"
  depends_on "sdl_gfx"
  depends_on "sdl_image"

  def install
    # Fix missing symobls for inline functions
    # https://github.com/jhawthorn/vecx/pull/3
    inreplace ["e6809.c", "vecx.c"], /__inline/, 'static \1'

    system "make"
    bin.install "vecx"
  end

  test do
    assert_match "rom.dat: No such file or directory", shell_output("#{bin}/vecx 2>&1", 1)
  end
end

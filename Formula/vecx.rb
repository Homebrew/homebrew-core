class Vecx < Formula
  desc "Vectrex emulator"
  homepage "https://github.com/jhawthorn/vecx"
  url "https://github.com/jhawthorn/vecx/archive/v1.1.tar.gz"
  sha256 "206ab30db547b9c711438455917b5f1ee96ff87bd025ed8a4bd660f109c8b3fb"
  license "GPL-3.0"
  revision 1
  head "https://github.com/jhawthorn/vecx.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "75779f24618178fb98ad78e8cdbfcbd9769a4878eadd6580f2fb4381ae9ba60e"
    sha256 cellar: :any, arm64_big_sur:  "085f8f3d413a6259c8dd804d4ad4cccaacadb2446eee33b1140d46e7bca7af29"
    sha256 cellar: :any, monterey:       "f3452a9fcd0b85f1c3debe208630b26d42e86be1af61a23336fa7c0f90753ad9"
    sha256 cellar: :any, big_sur:        "f00822462c70b4b6eb84c831b2c5d771b50671ecb1d51b7a03319e785f911984"
    sha256 cellar: :any, catalina:       "442ddb9d1e87e21f642e6785e170b3ef754ab9329c5ffd2d04b49b998f90f512"
  end

  depends_on "sdl12-compat"
  depends_on "sdl_gfx"
  depends_on "sdl_image"

  def install
    # Fix missing symobls for inline functions
    # https://github.com/jhawthorn/vecx/pull/3
    if OS.mac?
      inreplace ["e6809.c", "vecx.c"], /__inline/, 'static \1'
    else
      inreplace "Makefile", /^CFLAGS :=/, "\\0 -fgnu89-inline "
    end

    system "make"
    bin.install "vecx"
  end

  test do
    # Disable this part of the test on Linux because display is not available.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "rom.dat: No such file or directory", shell_output("#{bin}/vecx 2>&1", 1)
  end
end

class Vecx < Formula
  desc "Vectrex emulator"
  homepage "https://github.com/jhawthorn/vecx"
  url "https://github.com/jhawthorn/vecx/archive/v1.1.tar.gz"
  sha256 "206ab30db547b9c711438455917b5f1ee96ff87bd025ed8a4bd660f109c8b3fb"
  license "GPL-3.0"
  head "https://github.com/jhawthorn/vecx.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e1d6a1b7d28c46a7c0f2ec2eb26e5f15ba9816d0fb6e921a0f53af16f7088b84"
    sha256 cellar: :any, big_sur:       "6bfe8b690323619720d3448f5efef663787b0f4c8ad8296fb94f6ee3ecf5ff43"
    sha256 cellar: :any, catalina:      "8213a8cfb2f96374046f9952241ab34b2be01c4f2dd2988f39aa0b07e948ff60"
    sha256 cellar: :any, mojave:        "8e55a474a2d775bf3cbd0d7801b6d23aa3cf759d1aa48268542fee67cc6ab322"
    sha256 cellar: :any, high_sierra:   "2a2b5d63a8be0bcf51a9b4eee05b0751fd3757b5576e515931a55ad6f729a465"
    sha256 cellar: :any, sierra:        "9417cc9e5938dc117b4ab7ab41518a2b28e366cae15cdf1192af15e6237a35e6"
    sha256 cellar: :any, el_capitan:    "48d404ad79ecd0ac870ca0b3390a6465e7ed2755d58eaf130ec93a4e874e5f34"
    sha256 cellar: :any, yosemite:      "65e4cd91159f3772ec9e688d93bb1c1dd823e9c397b5163a62b1499909a2b74b"
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

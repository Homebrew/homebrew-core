class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.6.0/scummvm-2.6.0.tar.xz"
  sha256 "1c1438e8d0c9d9e15fd129e2e9e2d2227715bd7559f83b2e7208f5d8704ffc17"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "475156b3ba1117efe13e9ee0d9e0a91def31eb931fe58dfcb5fdf10a2f854c48"
    sha256 arm64_big_sur:  "e58cbe42ea584122490c49c90dbdf987e461123ae4a513c2061a8a97cf490da3"
    sha256 monterey:       "9a4b656babf0e9bdf76330ba2808f08d2001db012db16aa6741b27438b1d5483"
    sha256 big_sur:        "0d4083f17babeb6111af4efff100193ba244909724a45bc16e75cb16dffbb024"
    sha256 catalina:       "a4e2ac0382a5a65019959c7e6a057f581fdec68193c0c18441346de47ae40d7b"
    sha256 x86_64_linux:   "cf0002e331d175cce054f73ea60c99bb6c6634efde6888530eb142dd0cb6785d"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-release",
                          "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}"
    system "make"
    system "make", "install"
    (share/"pixmaps").rmtree
    (share/"icons").rmtree
  end

  test do
    # Test fails on headless CI: Could not initialize SDL: No available video device
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"scummvm", "-v"
  end
end

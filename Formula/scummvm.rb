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
    sha256 arm64_monterey: "9c02e29261c4a74a5bf0b87b43e48cd4097f101d8357d533192c8295d61b7b8c"
    sha256 arm64_big_sur:  "0c8d1b0dc89cf193d415aa8a0bbab69ccb0ba742e67e1e21bb9576bca1a6bedd"
    sha256 monterey:       "64e4ce5ab970c55f261ac3057a5fba90c934577b20a4767f984e831bf45b12f2"
    sha256 big_sur:        "7bb1f9aa31f752222ddf0f7a98a3ed685a16864009ef6b9b8a0d01efab7c2304"
    sha256 catalina:       "c8ac1fb55fa19dbeb6339a73739467e150840f77813e34f1a27d2af9a8c432ca"
    sha256 x86_64_linux:   "cd8e2f725818daff4f5ef6b810a39e1d67713764546049d78710db77edb2798d"
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

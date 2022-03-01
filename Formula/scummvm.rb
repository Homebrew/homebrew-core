class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.5.1/scummvm-2.5.1.tar.xz"
  sha256 "9fd8db38e4456144bf8c34dacdf7f204e75f18e8e448ec01ce08ce826a035f01"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "499e754572a4803c5ccd2eee366804ce51d239113db3aeb1f9473e30ced5da34"
    sha256 monterey:      "a59f32a800e4124e579c42d17401d914ba6c909125f06df01b96beff490fbe6e"
    sha256 big_sur:       "a0ca0490722005ea791c40103753923f20208941b757fe1003cd4702a8dd9f3f"
    sha256 catalina:      "37d16389dfcf103348c0c953ce6b5625f8e56959f27511bcf22555459974f8b9"
    sha256 x86_64_linux:  "4b5fb89756bfdfb9a15d073d8dea71096883683160395ccca09215fc1685bdaf"
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
    on_linux do
      # Test fails on headless CI: Could not initialize SDL: No available video device
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "#{bin}/scummvm", "-v"
  end
end

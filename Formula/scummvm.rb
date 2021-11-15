class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.5.0/scummvm-2.5.0.tar.xz"
  sha256 "b47ee4b195828d2c358e38a4088eda49886dc37a04f1cc17b981345a59e0d623"
  license "GPL-2.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "90d437657d306794297adcfaf083dd0bd951bbf437e8f7ff40c12413efa32376"
    sha256 monterey:      "f8d5919d8dfbaffc4b818decb7859fa37b7ad8d2689adaed5e1d8e9de4f67d7a"
    sha256 big_sur:       "f1543bc3553a0bae3a659f4c17412228cf6fb643c460ec3f488354d65ebcd27b"
    sha256 catalina:      "07e6e6c14491af15cb9900691fd60276568bdc66ef423752dbe4cde10d5e8bc7"
    sha256 mojave:        "b83003efb12c36548180f1bb883f02e48276078992b3916196c3495bd80bb9a9"
    sha256 x86_64_linux:  "671cc9da5228b2e1c6500083b3508bc41d7a9fe7c0b94f525732126bae4edb2d"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth@2.1"
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
    (share+"pixmaps").rmtree
    (share+"icons").rmtree
  end

  test do
    on_linux do
      # Test fails on headless CI: Could not initialize SDL: No available video device
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "#{bin}/scummvm", "-v"
  end
end

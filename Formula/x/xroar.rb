class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.7.3.tar.gz"
  sha256 "f88f4ebf852be4262935020f350d9ce55e2b054172f9851ba47fe34e10940dea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "34519adf33e18cd229ed996013c543deb11bd1c6b65ba98b7b009697cecc075b"
    sha256 cellar: :any,                 arm64_sonoma:  "8a0acaeb79606d1898ff89585e8b49c1ebbf7924ec0755ba080ccb784d6f4a5e"
    sha256 cellar: :any,                 arm64_ventura: "8d8557ef41fc4682f2e2672b8c26dd6f7117737b58342bd5d9cffe1b339b8fea"
    sha256 cellar: :any,                 sonoma:        "0c5abb10d693bf016157de298134af5633fae54298c77d1dd7fbc3971e38b925"
    sha256 cellar: :any,                 ventura:       "d5abd1b2906613201122ff2e08182a36f185d9c7a316eaf0618a43be10bee654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d16cd7482de3cad4ee6fab72f82c2d9ab4a181c36937042661e4b0ccf3e9d744"
  end

  head do
    url "https://www.6809.org.uk/git/xroar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
  end

  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "pulseaudio"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", "--without-x", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output(bin/"xroar -config-print")

    assert_match(/machine dragon32/, output)
    assert_match(/machine dragon64/, output)
    assert_match(/machine tano/, output)
    assert_match(/machine dragon200e/, output)
    assert_match(/machine coco/, output)
    assert_match(/machine cocous/, output)
    assert_match(/machine coco2b/, output)
    assert_match(/machine coco2bus/, output)
    assert_match(/machine coco3/, output)
    assert_match(/machine coco3p/, output)
    assert_match(/machine mx1600/, output)
    assert_match(/machine mc10/, output)
    assert_match(/machine alice/, output)
  end
end

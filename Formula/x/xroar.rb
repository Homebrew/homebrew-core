class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.8.2.tar.gz"
  sha256 "34431cc352bad47f70570243644a96bce54e877a6f7e348208fcae259835ae31"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "66d251d967c3745b9aa87eb67a82222fbc0fceec7f9610fc348226c86846b1d2"
    sha256 cellar: :any,                 arm64_sonoma:  "04fc798fa46ba0d83518a8fe26bf80e77b19afff2c41a9d4b7b739a6c8e9ac00"
    sha256 cellar: :any,                 arm64_ventura: "24372127bc5875450dca9f8508e7ae1ee523519f46e2503ddf584e833e213cab"
    sha256 cellar: :any,                 sonoma:        "c0bf5c651a318a9a23f4f97e76f7e6e4205f4b7557a14f58e56993e65a97a7d1"
    sha256 cellar: :any,                 ventura:       "6c32e3d2690b479ae90aaed59f9b035d458b78a0abffea17544a4a1115492cf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5499a115ff0ca98c9e01b4e08b99088b07c761cc8bae761f5b7b8c58e616e2ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf6d0b2ca8c7764f489bf159b86d9c9f0acf473968e11dd68a4ee67f59d599e"
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
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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

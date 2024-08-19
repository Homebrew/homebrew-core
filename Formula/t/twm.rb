class Twm < Formula
  desc "Tab Window Manager for X Window System"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/twm-1.0.12.tar.xz"
  sha256 "aaf201d4de04c1bb11eed93de4bee0147217b7bdf61b7b761a56b2fdc276afe4"
  license "X11"

  bottle do
    sha256 arm64_sonoma:   "af71103ec9bf9cb7fb31d92b2006c97b91d9d494c53dd95347f13f95e9b0bdbf"
    sha256 arm64_ventura:  "a2c5a282d6a59cc729bbf0bed690e73b586ccffd90042057e43a2682605c896a"
    sha256 arm64_monterey: "19a684ac826452df3f0df71ab60e5a6a2589ffd8f7aef62e1c056895af2d15e2"
    sha256 arm64_big_sur:  "20744061e4256be46a8e57e0cb949226485195e6a4f6f0f0c7466ed2c04b53f5"
    sha256 sonoma:         "d55ff8c7e43cb00530ec6ebf3b0d0dadba3de68399ead40136f41a7b50e3d413"
    sha256 ventura:        "eb1f904ccccb31aa8f600820fe1bd0baa32f09db0b9a375a3c11ed56ed27058c"
    sha256 monterey:       "b1b8b441d6903b19543287fefba2abdc9f4cf0e0a7afabb47d5773183047a659"
    sha256 big_sur:        "2cd7f81e03b5177321253168fd7364b640b93e32397ac0f32c6ddd8418740970"
    sha256 x86_64_linux:   "11f8a44432789065dda5ccfabf83be674ca7cf37232a47005e75033fdb54a130"
  end

  depends_on "pkg-config" => :build

  depends_on "libxmu"
  depends_on "libxrandr"

  uses_from_macos "bison" => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"
    sleep 10
    fork do
      exec bin/"twm"
    end
  end
end

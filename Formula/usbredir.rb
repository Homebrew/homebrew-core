class Usbredir < Formula
  desc "USB traffic redirection library"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/usbredir/usbredir-0.12.0.tar.xz"
  sha256 "fbb44025bf55e1ce8d84afc7596bfa47c8a36cd603c6fa440f9102c1c9761e6d"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url "https://www.spice-space.org/download/usbredir/"
    regex(/href=.*?usbredir[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a56fe37fbb55500168e5603be76b3a8dba035c18b045f651e314b815bfe0c953"
    sha256 cellar: :any, arm64_big_sur:  "a89e97d94c354d11169c45cad63fb724d3af150e55897c6e5faf45633445ae51"
    sha256 cellar: :any, monterey:       "16f4f0fc4e6ba97c15c7fe6442ab1f30ecce8d2748a7ed2acdfec258a0a6d3d3"
    sha256 cellar: :any, big_sur:        "a0022d1a55c4a1c9d66c95f0611afac389bc83d74d506f576cd884951781077b"
    sha256 cellar: :any, catalina:       "211eed5c2d4b71dd2b5c6b1f2b2782e1e788b774db086bb2b11b971114f7f4d3"
    sha256               x86_64_linux:   "79cf30502a92984c9e7f0edaed63ceab42aaeab123698071ab0f1702ffa5dd0a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libusb"

  def install
    system "meson", *std_meson_args, ".", "build"
    system "ninja", "-C", "build", "-v"
    system "ninja", "-C", "build", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <usbredirparser.h>
      int main() {
        return usbredirparser_create() ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c",
                   "-L#{lib}",
                   "-lusbredirparser",
                   "-o", "test"
    system "./test"
  end
end

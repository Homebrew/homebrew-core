class Usbredir < Formula
  desc "USB traffic redirection library"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/usbredir/usbredir-0.11.0.tar.xz"
  sha256 "72dd5f3aa90dfbc0510b5149bb5b1654c8f21fdc405dfce7b5dc163dcff19cba"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url "https://www.spice-space.org/download/usbredir/"
    regex(/href=.*?usbredir[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "301a06eaf3c9f51d349f92b75d898857aeebb882ec2a1a83cbe1101cc2c3a58f"
    sha256 cellar: :any, big_sur:       "1d29697803e3eec97d1d8ebe00d9dba354b1ad51122913414752380c0eedacd7"
    sha256 cellar: :any, catalina:      "ac6f36424efd438cd495ac1f2309b3d058541a43a71cdd0477cd5d4f602c130e"
    sha256 cellar: :any, mojave:        "16c79281da519d94bf5f10c1521e84f38e1465bc4f2835fa8ab9eb576af479cc"
    sha256               x86_64_linux:  "73ba4b4154c70fb9e65a95c36e6cf6e2eb7cd09c90c8aa5f2d844bcfb8502694"
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

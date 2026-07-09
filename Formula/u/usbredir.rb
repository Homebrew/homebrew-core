class Usbredir < Formula
  desc "USB traffic redirection library"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/usbredir/usbredir-0.15.0.tar.xz"
  sha256 "6dc2a380277688a068191245dac2ab7063a552999d8ac3ad8e841c10ff050961"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url "https://www.spice-space.org/download/usbredir/"
    regex(/href=.*?usbredir[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "abc432af08f1f179d62c85fc6f683e597fab22d36e41d3f63e30013391892157"
    sha256 cellar: :any, arm64_sequoia: "9e802affea255b4b4510b5985491f20a25d4e890d45894a32f566ff709b63414"
    sha256 cellar: :any, arm64_sonoma:  "7ae69db9be837baef0c19b6672d10da0cc466d3ff17cbe8deb86c492e5b1bc1e"
    sha256 cellar: :any, arm64_ventura: "e40f49cf40316f8812f7df47be812df5bf1269eb77bcf6079624499adccdc310"
    sha256 cellar: :any, sonoma:        "b30c9161cd179a576749dcf9a00ef50030fbdfe7fb6c93a05338dfc9b5bcf736"
    sha256 cellar: :any, ventura:       "f9d8eeb3c790e34bd9e457380922676ef663f3df8057c5f857d627a97fbc490e"
    sha256               arm64_linux:   "cba9904ac1855514dd4ebefd97d38975e6ab19b5ad919a3e7be447a794b2f408"
    sha256               x86_64_linux:  "a2e5043bd22e186e35537b39c64aa4c6360535a1cde629212b6c0ccf2c9a99b8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libusb"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <usbredirparser.h>
      int main() {
        return usbredirparser_create() ? 0 : 1;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lusbredirparser", "-o", "test"
    system "./test"
  end
end

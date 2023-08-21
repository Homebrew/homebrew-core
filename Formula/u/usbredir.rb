class Usbredir < Formula
  desc "USB traffic redirection library"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/usbredir/usbredir-0.13.0.tar.xz"
  sha256 "4ba6faa02c0ae6deeb4c53883d66ab54b3a5899bead42ce4ded9568b9a7dc46e"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url "https://www.spice-space.org/download/usbredir/"
    regex(/href=.*?usbredir[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "922c8ef4d850cc2f3f1a004c2d5859d950cb3dbb7e507e709068f50ef1a4ee65"
    sha256 cellar: :any, arm64_monterey: "766114e04f8dc5d0c3914d481ce916996421fd1bf346ef2e0a72505c5ed318a3"
    sha256 cellar: :any, arm64_big_sur:  "ecba2c1e3a49f6e4deafb9cfaf53fe147cf93fc758ae160167488bf387d00341"
    sha256 cellar: :any, ventura:        "80b97dc409ad5daaf07aef1bcd4b3455d6d98b7ddbc8094c4d71d5ceb49be3ec"
    sha256 cellar: :any, monterey:       "13ec692e76a7fe69488761de6fc3c3beea20dc14a8afe5175be44098e6e49712"
    sha256 cellar: :any, big_sur:        "1a5750dad9ec230adf8c51f5bffa902923e18622efc900712453977d12fcbd08"
    sha256 cellar: :any, catalina:       "ffe0226c57d557ff516255a2df0e73adde8f533acabf57094219dfe5a763513c"
    sha256               x86_64_linux:   "03790301c51f8239b4dc6d43e2c060ad2e6a85133daa915415aba4cd098d0a4a"
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

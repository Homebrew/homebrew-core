class Usbredir < Formula
  desc "USB traffic redirection library"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/usbredir/usbredir-0.10.0.tar.xz"
  sha256 "76de718db370d824a833075599a8a035ab284c4a1bf279cca26bb538484d8061"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url "https://www.spice-space.org/download/usbredir/"
    regex(/href=.*?usbredir[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6b3470eeeccaa4755b997102cee313d879e8b91df61c076ecbbc18c4fc572d47"
    sha256 cellar: :any, big_sur:       "26d2040e073333ad5e1aba9594f88c4450e7a9ee9780c8cc458267bea7e8c7c6"
    sha256 cellar: :any, catalina:      "1986f37f4c043ee0822fb0cc61049ab57a73871e94e3e64ad1896861be49890b"
    sha256 cellar: :any, mojave:        "04d2e58a8479304dba8f207283c5f740ea1a74440ecb3780aa4182025b268384"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libusb"

  # See https://gitlab.freedesktop.org/spice/usbredir/-/merge_requests/32
  # Remove when the MR has been merged and included in the release.
  patch do
    url "https://gitlab.freedesktop.org/spice/usbredir/-/commit/be1078847e4e05fffea888544457ef6a75c8f330.diff"
    sha256 "052b9352625cfefd96a4ef491b3f40b64cee5ddaca0ed0b5205ab6ef2f8882c5"
  end

  def install
    system "meson", *std_meson_args, ".", "build"
    system "ninja", "-C", "build", "-v"
    system "ninja", "-C", "build", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <usbredirparser.h>
      int main() {
        return usbredirparser_create() ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-L#{lib}",
                   "-lusbredirparser",
                   "-o", "test"
    system "./test"
  end
end

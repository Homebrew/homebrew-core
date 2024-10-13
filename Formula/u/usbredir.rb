class Usbredir < Formula
  desc "USB traffic redirection library"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/usbredir/usbredir-0.14.0.tar.xz"
  sha256 "924dfb5c78328fae45a4c93a01bc83bb72c1310abeed119109255627a8baa332"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url "https://www.spice-space.org/download/usbredir/"
    regex(/href=.*?usbredir[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "93df364f6c6aa2060c888db35acdedb3b77ca4a4ba52a27178cdc1524ac48982"
    sha256 cellar: :any, arm64_sonoma:   "630fbbf88672a673a284c1abc36a9a0dc1d0e12272423c39ebf0a1820f581756"
    sha256 cellar: :any, arm64_ventura:  "c38d15165e427c870dcb1a831cc703bee4abecc5975fa36987efe63a3c070a14"
    sha256 cellar: :any, arm64_monterey: "d1a04df082293fbe993458d742001dfd17dba76b7e13ea2df7867e75617750f0"
    sha256 cellar: :any, sonoma:         "4d34512af58a5a33de67df9e0d7944bd228dfcfa6942d4da3d5169fc4e550739"
    sha256 cellar: :any, ventura:        "19ab01bfbd50bce5bd72f7f8bdaa497847eee0351a00402d7dbbfca3daae5b80"
    sha256 cellar: :any, monterey:       "f6999448357d06ce4e2a655f594a6440612c1bb63e3e0a2db771b092f6b98f79"
    sha256               x86_64_linux:   "63aadf6d6e85a7e6474124aa780e42df47b3759e8aca7c5dc02f642fe7e64b6c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libusb"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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

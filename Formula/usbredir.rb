class Usbredir < Formula
  desc "USB traffic redirection library"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/usbredir/usbredir-0.9.0.tar.xz"
  sha256 "a3e167bf42bc7fe02c3c9db27d7767f1b8ce41b99ad14a4b0d0a60abe8bf56a6"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url "https://www.spice-space.org/download/usbredir/"
    regex(/href=.*?usbredir[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "71845b18ae16c2ebe1a321d8e7bc8916f5fb99917f08d34927c14118ac8e9d12"
    sha256 cellar: :any, big_sur:       "8f86636870cc889d4a8ef202fdf4d65681e930961e19de50438deb49d1d2065d"
    sha256 cellar: :any, catalina:      "c7182aed390cc4cf96e9a99a728129367714b954062b7f92471a6e3864aed244"
    sha256 cellar: :any, mojave:        "579f1db366d50c027cfd6ea92149878b358d86bb6a9d491320e5f7fd62dfd2e8"
    sha256 cellar: :any, high_sierra:   "0d83ca33451b2c382dcf4b70be515549db139b0960712dc7f213e993ba7973d7"
    sha256 cellar: :any, sierra:        "7feac9566048e308877ef3f3d1b93660433dc8f1611e3daf031eaa4dd90c7238"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    # Use meson from the release after 0.9.0
    system "autoreconf", "-fiv"
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
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

class Usbredir < Formula
  desc "USB traffic redirection library"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/usbredir/usbredir-0.8.0.tar.bz2"
  sha256 "87bc9c5a81c982517a1bec70dc8d22e15ae197847643d58f20c0ced3c38c5e00"

  bottle do
    cellar :any
    sha256 "c7182aed390cc4cf96e9a99a728129367714b954062b7f92471a6e3864aed244" => :catalina
    sha256 "579f1db366d50c027cfd6ea92149878b358d86bb6a9d491320e5f7fd62dfd2e8" => :mojave
    sha256 "0d83ca33451b2c382dcf4b70be515549db139b0960712dc7f213e993ba7973d7" => :high_sierra
    sha256 "7feac9566048e308877ef3f3d1b93660433dc8f1611e3daf031eaa4dd90c7238" => :sierra
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  # Upstream patch, remove for next release
  # https://gitlab.freedesktop.org/spice/usbredir/issues/9
  patch do
    url "https://gitlab.freedesktop.org/spice/usbredir/commit/985e79d5f98d5586d87204317462549332c1dd46.diff"
    sha256 "21c0da8f6be94764e1e3363f5ed76ed070b5087034420cb17a81da06e4b73f83"
  end

  def install
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

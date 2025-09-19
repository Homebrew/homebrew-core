class Twm < Formula
  desc "Tab Window Manager for X Window System"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/twm-1.0.13.1.tar.xz"
  sha256 "a52534755aa8b492c884e52fa988bac84ab4d54641954679b9aaf08e323df2c5"
  license "X11"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "10c97cb0c9229ad2c77532f6c83736b5e31eb33dc08fe84cd2bd8f7545c56c64"
    sha256 arm64_sequoia: "55081cc48b42c43ff5affd9958066960f6e178282d70022d70811ae3c6376d91"
    sha256 arm64_sonoma:  "1cfdeb205b58d944d90a7a9e46cdb1fb38b2562512b780e951ec746e7da97ea9"
    sha256 arm64_ventura: "2674ec6c6954c05425a89ebe7833f275defe6ccbd8bdd550c26a78f86159f7af"
    sha256 sonoma:        "e1caa71427548f73cec6e7e4c43249b4293979ba2f90731c1add941f86c7b4f9"
    sha256 ventura:       "003cc59faaf5062d86c004e73c46d501b635999f8e743375fd7b6d301b183639"
    sha256 arm64_linux:   "4371c26596b82bc06d424f527663fd20cee9d63b301b712c38d0fd95d5ea1ab7"
    sha256 x86_64_linux:  "6993e42ad8cfc6af686eeadf5e0c970b4d23de655c5485562b14f34997c1caee"
  end

  depends_on "pkgconf" => :build

  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxrandr"
  depends_on "libxt"

  uses_from_macos "bison" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
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

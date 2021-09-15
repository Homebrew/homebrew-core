class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.11.0.tar.gz"
  sha256 "3648eca472a92a4e8fe55b27cd397b1bf16bad0b24a3a1988661f44553f5e2c3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "d4e19469518f0167a6abf40625c3c21df88bff1b2ca19bb6feac1c4a5a077cd2"
    sha256 big_sur:       "ae46d4c867f0f761368e22c80daa9e0805c15f7fc5855bf32d37575c36168367"
    sha256 catalina:      "b9a09483c45610c81dd29fc20a41b4fa8120e1353f736bb637732d4788e4bb28"
    sha256 mojave:        "c90bdf1ac012129c5d4caecd3e5acf2d110ca8cd68a8bcff6de07373149424db"
    sha256 high_sierra:   "2370d829c67ca1df886e47aca162c68034e138a10a93b846c31f1c927d84c435"
    sha256 x86_64_linux:  "a1aa65f57be2296d34ddf09f7f0e84d0357b1c9391296bcecdd2e28ff3fda483"
  end

  depends_on "cmake" => :build
  depends_on "fltk"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "pixman"

  on_linux do
    depends_on "linux-pam"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxft"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxtst"
  end

  def install
    turbo = Formula["jpeg-turbo"]
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/#{shared_library("libjpeg")}
      .
    ]
    system "cmake", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/vncviewer -h 2>&1", 1)
    assert_match "TigerVNC Viewer 64-bit v#{version}", output
  end
end

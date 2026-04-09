class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "b107c0c8b8a962594281690366c24186e95c2ea4a169acbc0076aa62ed01f467"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5e954d7bea96364530c4b075f7dec0f12a37c32ee077ed754d8064ad50bb870b"
    sha256 cellar: :any, arm64_sequoia: "70cbb58dd9e57fb894a63ccaa2f5c59eac87556f8ad7e9a8e9e1eed5d05561e6"
    sha256 cellar: :any, arm64_sonoma:  "385f5bc6e2df05e003aab535f4176dd58ad78055a1486ba2aa975879b1a649d8"
    sha256 cellar: :any, sonoma:        "ff39dfdbe929fcddb28ccc42a06a625a781c623835ad2c0dcfa99d75161c1d4c"
    sha256               arm64_linux:   "6d491ccec6f4b1c5303e29f229bf8eb949c64b4b46b0600c1323a48106e186ee"
    sha256               x86_64_linux:  "37e411a0aea25ffb7dec3c7bd4f1fa4576bb13bbe2320568e645af88ffcc6c3f"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "fltk@1.3" # fltk 1.4 issue: https://github.com/TigerVNC/tigervnc/issues/1949
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "nettle"
  depends_on "pixman"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
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
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/vncviewer -h 2>&1", 1)
    assert_match(/TigerVNC v#{version}/, output)
  end
end

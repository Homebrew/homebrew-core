class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.4.tar.gz"
  sha256 "3f3f7b7b26cc150dae7e1cae95a0fe2c65905311fe143145b4bcda8f97d7ed4e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8f12d10a964bf50201c0bbfcd56d8e36e535ad0f6e9e51e99d48666b7c713723"
    sha256 cellar: :any,                 big_sur:       "3d9b90b06dd6f6d3ba28fa1525101ed143810a1cb96203d0d95363d78fad1dfc"
    sha256 cellar: :any,                 catalina:      "e92ec1e1f654338dc3507424f67c2120eecb6f8159fcbce7e3d4939b97167b98"
    sha256 cellar: :any,                 mojave:        "7c3971a7ed6d4c363e65fa0ab03d84544c0ad25ae09115e1b08f847a313e7394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0af154f6157a8377d41e02c058f9d6eb15b01bf68fb224c4d3f1d3ae8bc4eaa1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end

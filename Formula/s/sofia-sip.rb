class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.net/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.16.tar.gz"
  sha256 "125a9653bea1fc1cb275e4aec3445aa2deadf1fe3f1adffae9559d2349bfab36"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "262dc862799700c5dff589548f224eca25f9832cb7f7b5816d6572259fe52b8d"
    sha256 cellar: :any,                 arm64_monterey: "e4d08ce84ebaf37bf91b11eef9485eea17539187663a5046ac69b6d2c08c6494"
    sha256 cellar: :any,                 arm64_big_sur:  "9c46d7adcdaf2289205bb2401fbc165b1d3d754ee95b9d4b4f54f3f0a39ae7f6"
    sha256 cellar: :any,                 ventura:        "1132c7c2515879d1911bf2a59b62a83ecfd4ecf1d0b9209a39e1b1022b202e01"
    sha256 cellar: :any,                 monterey:       "394bcdcd427901d26872d5b788940651b73dc20d51c34b4a221b1ee2471f0f8f"
    sha256 cellar: :any,                 big_sur:        "233145304a443c3a588ec3f6fa535418012ce5f93e92624d5e7eca05c861eb88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e53bb336e275f17cc23454016ab71d4613b5d6025c579b71c46b717fbe40f34a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@3"

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

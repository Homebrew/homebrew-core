class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.6.tar.gz"
  sha256 "6f3cb48a35929abd3454087b32ad4c75fa5fe50fab8a9cc6f98559e6fd1bd64b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e8e5655133dbe792ce9686538f8b9ac6a18174c1f6325abbc25b65dd66a504f9"
    sha256 cellar: :any,                 arm64_big_sur:  "c0d8e1a4495af7b3052d85c76e8b3c1a5587e3b49a46925b9f5ea5f585cd0895"
    sha256 cellar: :any,                 monterey:       "b205c1d6762b4961b7e6f94d1233d874345143c850f56f6fecbc88b2c0e873ae"
    sha256 cellar: :any,                 big_sur:        "6f2bc64913d1a3205c627cd87cc011fd559574ec4ea581a525118649a2504896"
    sha256 cellar: :any,                 catalina:       "e402cc99a8c04ea17e461d1e82a5a44ceb93b183913a353d3193698193d1ead2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc7fcb25bb1b1be2290c7025084c08ce01f72a2149d4bd3a79931a4e780686e0"
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

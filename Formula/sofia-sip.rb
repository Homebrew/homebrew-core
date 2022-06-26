class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.8.tar.gz"
  sha256 "792b99eb35e50d7abeb42e91a5dceaf28afc5be1a85ffb01995855792a747fec"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4a9236cfca7bdf5f2b0150c43b6880bb3228aeb74e78f4ca5d90b23e7629345e"
    sha256 cellar: :any,                 arm64_big_sur:  "ce246432a246e2d745544771006439d443b639b5a40c7e155c13d8e4b6d1175b"
    sha256 cellar: :any,                 monterey:       "4634460ca33e34cca0c8261a164f1b17d9585ab4824836f78518dc52d945e543"
    sha256 cellar: :any,                 big_sur:        "34823f7ddba4cabc4ecfbd38441f2a0efec3f99dcfc05203f15b2c69d3ac8ab8"
    sha256 cellar: :any,                 catalina:       "6c76cd5a4ddbcf0f886a511baa0dfd351a25f1f49ec38ea5bf73f29d7874a78a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1508be4f8955a341f1e100e657a260ae2e291325a36e1fe71d42664a095cb112"
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

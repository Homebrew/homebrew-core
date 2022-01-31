class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.7.tar.gz"
  sha256 "3bdcbe80a066c9cafa8d947d51512b86ed56bf2cdbb25dbe9b8eef6a8bab6a25"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f035ecd9ec07ec02c1850ba3882ef38bbeab8d92fbc145d4e4b42f08409d6f6b"
    sha256 cellar: :any,                 arm64_big_sur:  "4922057de55691e7efa47b07022b4f124056e26d8dc6f643ac44e3317bca1fd1"
    sha256 cellar: :any,                 monterey:       "8848fef39a4761a422afda73ce5f65375b2c322fab3ae6788bf531450e1b2ac8"
    sha256 cellar: :any,                 big_sur:        "c902aaf18cfac60a6087b6ac09b42e41e3f21370b158d4c060de409deeb4fac3"
    sha256 cellar: :any,                 catalina:       "4ed76a63a643691503161e3c9898eae8306e9a7677024b2d7543d8174be68f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcba17bce3dd1c7189b6acc4133adb5785020ca865f6f41ae90ff520bb0369a8"
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

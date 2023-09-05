class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.5.tar.gz"
  sha256 "ab04ad76d5302fccce93b167324b5f08c2384c980f9a046bba934e8358d62c0b"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "7331492460379fec1022f135c2f1323730870e292b5a0875cd6e2e77dae4b543"
    sha256 arm64_monterey: "192904bd8f416f581149263942a88666f4d4634db355c6014e98504f08d4798a"
    sha256 arm64_big_sur:  "fe358a4ff927933060ce39c6be5738f59b745da7a29568aa01aec10657088fe4"
    sha256 ventura:        "140b08e18de719c09098cef83a018de78af2ee96ca8507e0a737b37ea1c7f55e"
    sha256 monterey:       "f73ee1a63276e87d567f366f074b5fe7b8f63c14c6ba18ed3d089f299819c020"
    sha256 big_sur:        "903cfca33c4b72ee83112aaeca2396f506f428bcd319205d5ec244456cbd322f"
    sha256 x86_64_linux:   "3fb8dba52f440188524cfb470afe73769e0f8467bf812c3568d573cffb29046e"
  end

  depends_on "pkg-config" => :build
  depends_on "libretls"
  depends_on "openssl@3"
  depends_on "rsync"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--with-rsync=#{Formula["rsync"].opt_bin}/rsync",
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  def post_install
    # make the var/db,cache/rpki-client dirs
    (var/"db/rpki-client").mkpath
    (var/"cache/rpki-client").mkpath
  end

  test do
    assert_match "VRP Entries: 0 (0 unique)", shell_output("#{sbin}/rpki-client -n -d . -R . 2>&1")
    assert_match "rpki-client-portable #{version}", shell_output("#{sbin}/rpki-client -V 2>&1")
  end
end

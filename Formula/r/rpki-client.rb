class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-9.8.tar.gz"
  sha256 "42920aac5afd0996173fb9f7848691a2c49dd234e4f10478808c1aa475620861"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e2046b634e5c22f5f138c84ec00a3b87e91183f1225a3ae89b92b1796ad55cf3"
    sha256 arm64_sequoia: "586c2128b794170082532594973c514a084a0cdb38a78c58c915e31bb2c4494a"
    sha256 arm64_sonoma:  "3f3f3a80380649cc00fd85f271aea649e638ceaafc380c175cad2b19b2d32141"
    sha256 sonoma:        "1d6e2ae0e9a8b7af170cf6e0c9ed0f279c324af15c2c333d0ed04dcb97c6cc16"
    sha256 arm64_linux:   "80b7ca5e644eb72c11a7a8cadf75b8f0a9503fd9d128daabd900f7c1b84fb965"
    sha256 x86_64_linux:  "0ff89bba365126182697998eb6d0b35a8e8009b16b126849b32fe6f85b6f3cf5"
  end

  depends_on "pkgconf" => :build
  depends_on "libretls"
  depends_on "openssl@3"
  depends_on "rsync"

  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--with-rsync=#{Formula["rsync"].opt_bin}/rsync",
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          *std_configure_args
    system "make", "install"

    # make the var/db,cache/rpki-client dirs
    (var/"db/rpki-client").mkpath
    (var/"cache/rpki-client").mkpath
  end

  test do
    assert_match "VRP Entries: 0 (0 unique)", shell_output("#{sbin}/rpki-client -n -d . -R . 2>&1")
    assert_match "rpki-client-portable #{version}", shell_output("#{sbin}/rpki-client -V 2>&1")
  end
end

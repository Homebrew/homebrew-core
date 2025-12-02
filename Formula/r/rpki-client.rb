class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-9.6.tar.gz"
  sha256 "07cbd27af99f1b6096769e697e38631519c69cb642bee3af39a763fa1590d947"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "42d259bddcd32b86eb962546f4a088195fd7ca8125b3aefc1dde8625a86b6797"
    sha256 arm64_sequoia: "35b00ae46c842aae7411c34ad5fe9255d4e180aa756f08daf5b1cbc080f34910"
    sha256 arm64_sonoma:  "4f22703245950d0ebd7c5a7e662ecd6373cf94f518a4e22a7c54bd7c7974ee40"
    sha256 sonoma:        "e154847feb5187f472c879a617a9a92e745da360c56800bab13b2b678c1f3d0a"
    sha256 arm64_linux:   "e1a5721721fad2983f1490c8a13aef2abecbf31b34d723e99d9bd45cdf81c586"
    sha256 x86_64_linux:  "a80ae44f8922d35091af5955e3ae1abdbab8e9ae15624d81b6726b047f91d465"
  end

  depends_on "pkgconf" => :build
  depends_on "libretls"
  depends_on "openssl@3"
  depends_on "rsync"

  uses_from_macos "expat"
  uses_from_macos "zlib"

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

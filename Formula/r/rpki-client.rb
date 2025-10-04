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
    sha256 arm64_tahoe:   "386aed54aea55578ce811e6142d56de455e5ffcb741dd1ef7c7742d6093df26c"
    sha256 arm64_sequoia: "22c0ecfc8181ea41b2b1820a36efeb70eb72ded706502cf2e750806680904728"
    sha256 arm64_sonoma:  "99c30f0e4caf53f5487c9760e0a5eb3b6b693a90800d00531131dacfb52a7087"
    sha256 sonoma:        "b99f81eb26b79235ef46dcb35b709b0a2aadebe44107e25e2f64b742415ed5ce"
    sha256 arm64_linux:   "f80741224cd761de78a16c2b085e34098d13e2ee92499f17cccfe92d61d75d0a"
    sha256 x86_64_linux:  "14dd3402ccdebb577ec400dfd337371266503e190021934669474999906d3468"
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

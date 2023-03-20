class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.2.tar.gz"
  sha256 "dc0d19679b57ae657b92d21730b1678823974d43300faa8c24ee155c1e2b1d64"
  license "ISC"

  bottle do
    sha256 arm64_ventura:  "68a2394a47e424d5d218407ef2e7a13486c3a41b63851ee490a314af6d3a1c67"
    sha256 arm64_monterey: "5e6403874007d3bc810a048fdb839310df6e5f19539c1ab4f4692101d10e3131"
    sha256 arm64_big_sur:  "ec6f3dda6f8c51227aef2af0efba137b2b64f998f134c88abc3776c5b1d68430"
    sha256 ventura:        "293a75b60c4069562cf6c836eab505bdbc282050b6c866029cccd548e06bbe5c"
    sha256 monterey:       "e9ea8b936428ad9685f7b7534b79db17bf68a46ed14601d3781e5a3f796fa81d"
    sha256 big_sur:        "4d409a946b1efb77e0667cd93aa5f62284db34a3f3800e99759f89cf59b9f9e6"
    sha256 x86_64_linux:   "90f625188abd2191d12b7b0a4f4304910071b15aca3aef0b8a2003db62d7a142"
  end

  depends_on "pkg-config" => :build
  depends_on "libretls"
  depends_on "openssl@3"
  depends_on "rsync"

  uses_from_macos "expat"

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

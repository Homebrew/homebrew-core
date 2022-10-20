class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/index.html"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.0.tar.gz"
  sha256 "5b710ccee2e7e949587e54daf823811671174a50c671746e5a276afaa0ce55be"
  license "ISC"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_monterey: "9059d0885296268782caa8d7227c5fa36b2a0e57671067bd88468245cbcd493a"
    sha256 arm64_big_sur:  "5420908d212f7719ec7519b60b7ff5ee83c91c9bafd5690ee9ce8dbe3ff55b21"
    sha256 monterey:       "4b96fe11c1d96b719600e01291a228c98bee810520ba35e7864b43150a17a826"
    sha256 big_sur:        "29eaddeaa39775a5f9ca600bc156b123ec38ff237a4c16d84b587f470ab3d776"
    sha256 catalina:       "c08b8ff4249d882e1558e5784c4cada008198cf90080c98ec6ad854c0fed27b9"
    sha256 x86_64_linux:   "3f4cbf4a7fcc4a365b69aa661fc9b6698abfafeabf4afd1f98ce4ce16b900920"
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

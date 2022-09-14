class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/index.html"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.0.tar.gz"
  sha256 "5b710ccee2e7e949587e54daf823811671174a50c671746e5a276afaa0ce55be"
  license "ISC"

  bottle do
    sha256 arm64_monterey: "69384664e6a739e4a961434920a17a0b70033383c7c688cbb350af5ae06b01a6"
    sha256 arm64_big_sur:  "1396185417a4287311398c2ee298dc1673a13beda4fc93c84ad5e537448a4e56"
    sha256 monterey:       "9dee973ef3c51bb9ade9d0e0b154f09ddca26c42fed785a9356d5c780c0335ea"
    sha256 big_sur:        "cc11ae071a0d37348fc60d4980551db9c4aa56dcc513fe32cab4a75bffedb974"
    sha256 catalina:       "5b1e79efec36ee324bb3acd1f7e14bf58fd31be3b2355a752ac207ffbbbf0b6f"
  end

  depends_on "pkg-config" => :build
  depends_on "libressl"
  depends_on :macos

  def install
    system "./configure", *std_configure_args,
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
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

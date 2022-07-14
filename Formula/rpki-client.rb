class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/index.html"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-7.9.tar.gz"
  sha256 "accf531c885a9d95a37a6627399a59b360fa29a11810aba15b27d7526ce43e75"
  license "ISC"

  bottle do
    sha256 arm64_monterey: "3e61ce6a33ccc4852aa3dba1bbfeeb256eeb84886db3b627e4c7ed2cfa3a0538"
    sha256 arm64_big_sur:  "0f982491437041f53160c0248e653c2e1e0d40ba4dd7c767168fcd8bab76ae5f"
    sha256 monterey:       "00450aa3f5296beb2859a654b12fdf4c2f841755d5d07e91a8cefbc82f2ff35e"
    sha256 big_sur:        "e2a3f21af703e38864d15c7fcde0e5acf0802bd4ddb292fd35761d414c5b5cba"
    sha256 catalina:       "cf6086ae67b81b0dd49b1befafc83fb942377d5a5ab1f400a80db11de4a6e1d7"
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
    assert_match "VRP Entries: 0 (0 unique)", shell_output("#{sbin}/rpki-client -n -d . -R . 2>&1").lines.last
  end
end

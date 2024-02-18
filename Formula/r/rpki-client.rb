class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.9.tar.gz"
  sha256 "17d2e56f5231d0ac96e60a9ea739848b17da29f57b260648da478077a3cea7ff"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "80481fcbe3972493dee45cf7562521d8b57ef28e6edcdf8d901bed3b0a940f66"
    sha256 arm64_ventura:  "50407b657ab4079f78b324cfb563f30150b24086939059b10499704081368d51"
    sha256 arm64_monterey: "07d047d8d14726a6d607b6c67aa0b17f384ffa478df9931f69b8a671db7e61db"
    sha256 sonoma:         "298737231cf099f149cb3bb3089381ce9849f54c93de4e7ddaaafb0e1b2e5686"
    sha256 ventura:        "9b4fe2e5309328ebe1a2ad752fe9452ab425a6464ed5bcf367fcd3abd21d3319"
    sha256 monterey:       "cb667a6f8778a5db25bf9721de249ee50ea4a8d9839427a2dacb7daa9c260a32"
    sha256 x86_64_linux:   "53318b17b92ca18e9af9b9da88e93c9476734c740020c6b1dd1cf492b2085997"
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

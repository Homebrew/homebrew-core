class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-9.7.tar.gz"
  sha256 "fdb3b36e8348a97bb9a37986755cdfc3331a47d2fd684f6814d23cdc63efc9ec"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f84ace6b47e2b9bb4369c7af04295ca4d3f301d80f7a7c60b73d2d8c6319efb2"
    sha256 arm64_sequoia: "73da58103c83651c9e027fa4c19fc536fe34bae95c334bc28690a64d90f74d06"
    sha256 arm64_sonoma:  "62efc050d491006edcee2c58c224ea6f48ffac2cfbf79ae1621500638d9aea63"
    sha256 sonoma:        "df32ad665c7a04a0beb5ddf5c26d0ae1bb064117ca8b5462b162af68c148a378"
    sha256 arm64_linux:   "e5676cdc91c73e9cb518eec17d84c356db80e11fee1903ece465e13c9321d9dc"
    sha256 x86_64_linux:  "0981737e861d734d2a67ac2d61c674eb3e6cf9e0d49cad7fd1c0657e80d77337"
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

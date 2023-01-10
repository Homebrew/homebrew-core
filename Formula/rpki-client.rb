class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.2.tar.gz"
  sha256 "dc0d19679b57ae657b92d21730b1678823974d43300faa8c24ee155c1e2b1d64"
  license "ISC"

  bottle do
    sha256 arm64_ventura:  "5174f0f8ad8c4f703aabd4a95431bef8e793b98819ae62dc375efc1143de76be"
    sha256 arm64_monterey: "0f0e12dcc765439340d005b89713afc888c3c43a08c39008679380e41566cdaf"
    sha256 arm64_big_sur:  "8897f02df93019175167ec36b8384bc457ac91e6ec31db468599dbcb2d082133"
    sha256 ventura:        "35d437fe4c0bf152e8406d6b02b484c373f1a0463a72c921feb74e25df208a42"
    sha256 monterey:       "deb08c58cd55a113823c2abcd099a4c54e1977d2ab3b5a3fd29622e8bc46ca86"
    sha256 big_sur:        "3553bd4f41316c7eb13a8653b7ec141cd94cc06f0703f07c2fca1f5e74d60373"
    sha256 x86_64_linux:   "17ca03fab715c3001ada7fe58a41bd737718959b76b7f0ff1cc525c566b2cf74"
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

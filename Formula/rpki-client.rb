class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.4.tar.gz"
  sha256 "cac9409566a98c7a89e4e08a1b0f377627d92b5e065f4066a2b4eb7fec7869c8"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "35f83f308eba81a6aba8d915a9b7ce3d9b74651a02bb0006d5a22d63a69e0bc3"
    sha256 arm64_monterey: "6ab9c1154ead8d42931a61f5ed14ee7fb655b525d797c84f3e2414cb0eef2d10"
    sha256 arm64_big_sur:  "bbac104a31b2e7f6985478969272df411248741134fe3e1c885e13154fde52a4"
    sha256 ventura:        "c50c8f9cccb5670889df7d17987e6a5a6cf7103fa59e4ee5f130f84bbdf89ed4"
    sha256 monterey:       "09aa7f1d0ee6be4e33712765b19283816fbe3e5d651ba83915de2fe018dc9c48"
    sha256 big_sur:        "027447221a265cd417882b9d155edde9c092161ffd6d400575ffb81959e4587e"
    sha256 x86_64_linux:   "4c71c6c63c2c74f9d6eed08d93933274ee7dacbe7d89806b69c94852d7669672"
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

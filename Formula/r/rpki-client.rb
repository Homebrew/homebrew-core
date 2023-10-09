class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.6.tar.gz"
  sha256 "2342cb85eff65ac52fe9e52c2eebe05436af6c5661d649da8e922616ecc8693a"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "5e96f98b25c11096f8f035269104f334d23b3a58de6ca6d9d98471b21b0f2c32"
    sha256 arm64_ventura:  "421fe3e7de92196d31f28365ede9c281a6a80af2aa6ae2388d0e9e974840122a"
    sha256 arm64_monterey: "4ed0bdfa22bc7b7ce57408e6c29db511d9e2eaa987281fd8f58350448887d736"
    sha256 sonoma:         "2b39a646479e5c7935842d52fe09040655a327e5422653d33bf089250b85e40e"
    sha256 ventura:        "0a11274093f668c939427cfb84613a411ac86101328e8ff9c5f9132824fbfd07"
    sha256 monterey:       "e91aa57c4aa0506de7ab0b400f50f2bb9ee800f9cb4ed94dc075d8668fcd2837"
    sha256 x86_64_linux:   "aca37eef01b7ffe8db5e4207f277eb50427a7f5e8604937953d6801b810bdf40"
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

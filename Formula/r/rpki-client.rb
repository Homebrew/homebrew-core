class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.8.tar.gz"
  sha256 "c784b929c68ea57f674f3e0371c410c35d75da7397d654dd83af66c7072ee667"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "03a0769722be04e495590f95856c5223052847facdc4e00de4387283255edb71"
    sha256 arm64_ventura:  "60e524571830d9c77eebb152baa0f3a46a6bc1b16c80d90658c37f218c973ee1"
    sha256 arm64_monterey: "048d9f36c47991f7815c69f41d82c2ef0edd4e5ef6266914edf121896b9e25f7"
    sha256 sonoma:         "a16ca556cb2bc742ef4d8c93480f6e30573c016ad8477fc871f450a61efe91a8"
    sha256 ventura:        "ce2909eacad8da9039271e8b0a4235b0af858ace730be76e5737f99134f151ef"
    sha256 monterey:       "ac35a1fcb06f1912716ba67b612024a14f5933c8a1274bf0020cced6f2bb1108"
    sha256 x86_64_linux:   "ea1cabc19bd818440441cf3c290aecd5c8139d421a5b7acad3f697a220034586"
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

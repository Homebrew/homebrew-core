class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  # TODO: Remove `autoconf`, `automake` and `libtool` dependencies when the patch is removed.
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.3.tar.gz"
  sha256 "8c78f82ae959a900f47c7319cbf7688182cde39dcc4c4b9aa399a142be4dc143"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c0e289b603ba35475efe37a5e77898340f51053ee9552e4bcd3091b9c4bd48a1"
    sha256 arm64_monterey: "6fe2d161437b5ada9c7f434b7370bc9c3e520338d142931a4b00ca575c32349f"
    sha256 arm64_big_sur:  "9d9526100ccc7026d1c70489531b96b179c9a76fb6444eec4d70183d27086a57"
    sha256 ventura:        "88ac4c2b8189592d68ce7b9329398ec640b1ecd90216f15033e29c8c5ff48a7e"
    sha256 monterey:       "ea1324c9dc5f09b4cf64fdc421f14696dee0ad497a148c6f96c890c5d38e39c3"
    sha256 big_sur:        "9a3d781d801fd922d1b633bf967258f8329ddb6490918780507e935a9820a23b"
    sha256 x86_64_linux:   "ce7e879d64cb2909aa292f6478c8e04d73957dc70a7ffd42622fff4099a8bf79"
  end

  # We need `autoconf`, `automake` and `libtool` to apply the patch below.
  # Remove when the patch is no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libretls"
  depends_on "openssl@3"
  depends_on "rsync"

  uses_from_macos "expat"

  # Fix absence of `HOST_NAME_MAX` on macOS.
  # Remove in next release.
  patch do
    url "https://github.com/rpki-client/rpki-client-portable/commit/65e5d4b99131b7cc8091ea222b70d24ec04fac60.patch?full_index=1"
    sha256 "014b522efa2f656853b42673ac7bf592ed662468d911b251c918b0154bac0a3d"
  end

  def install
    # We call `autoreconf` because we apply a patch. Remove when the patch is no longer needed.
    system "autoreconf", "--force", "--install", "--verbose"
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

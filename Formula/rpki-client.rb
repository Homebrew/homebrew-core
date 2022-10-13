class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/index.html"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.0.tar.gz"
  sha256 "5b710ccee2e7e949587e54daf823811671174a50c671746e5a276afaa0ce55be"
  license "ISC"
  revision 1

  bottle do
    sha256 arm64_monterey: "623b0dd6c256779701eb52254d0e1c60ace412273099bd0cd5a982a463a9a9aa"
    sha256 arm64_big_sur:  "42de45a25383dd2268602fbdb50911b2710488a0fe7ceae14789ce0c45194b24"
    sha256 monterey:       "182a345138adf92b28e0ae5fd116a39a2d89b7716c7e3d7c99ee17c5a1c24f2f"
    sha256 big_sur:        "087fb52498765b261d100fd124e170c752fdc3e8f024ca3acd7687ef8b123c95"
    sha256 catalina:       "e1e6ab2bc911f12a579eeb5a9776d61e817e3ad13717d82e083b65c34130945e"
    sha256 x86_64_linux:   "09688cdc813f3d65995b5279dd8cfa656dc30ce8b3c7b0f25770a20d84f9e071"
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

class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/index.html"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.0.tar.gz"
  sha256 "5b710ccee2e7e949587e54daf823811671174a50c671746e5a276afaa0ce55be"
  license "ISC"
  revision 1

  bottle do
    sha256 arm64_monterey: "68bf3dee8842b4377f8756903973f9a1097c86080d3411407c52180f3fad2c2f"
    sha256 arm64_big_sur:  "7c3ba8df894ff5a2c40b5d23000cd6cbe45bb19ba78deac79e5a370935d74ee0"
    sha256 monterey:       "3ce0c48f6363bf20ac17cbc43d0343725bf66643d36108feecfba9916683c39f"
    sha256 big_sur:        "bde420294c6be156837f03e0b7ca82a74813dbdbfae765e8d5794820f9c27ce6"
    sha256 catalina:       "38700db72a087f872572a10debe6100a8983bd04da18ca0d1143b0ae902bad8e"
  end

  depends_on "pkg-config" => :build
  depends_on "libressl"
  depends_on :macos
  depends_on "rsync"

  def install
    system "./configure", *std_configure_args,
                          "--with-rsync=#{Formula["rsync"].opt_bin}/rsync",
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

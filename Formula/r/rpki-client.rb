class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-9.4.tar.gz"
  sha256 "f3bd2cda5517826b717c574f122ee075eb35866b923b558de6a2720517f0bb6a"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "b159435cc16a2e5dc94aef656a44c3fae592ff761af859a9eaf89d97342c2692"
    sha256 arm64_sonoma:  "d0ce6065e42669a5b317d783029bd4a6a694db9f4d86a49cc2fc5bdd6bc8ecce"
    sha256 arm64_ventura: "ea84cf4764b4689397031f4ad212699642d5896baece5dc4f89a3006f1c40c03"
    sha256 sonoma:        "97433f4e2de90132dd86bbe767ad45a93b34f037b77f2a767f9724f16e9c69b0"
    sha256 ventura:       "a8071143e5de9b7ba1032794a3bfef5580a6c6a2cac24f77d1cd597dedb717bb"
    sha256 x86_64_linux:  "e96386683cc04c1467d92b92d2f38bc6cf9d1deb1f42c208c557f9a89a57259b"
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

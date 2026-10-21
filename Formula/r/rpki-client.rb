class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-9.9.tar.gz"
  sha256 "24985845b7283b071942c9fa44598517461211ee32a690a219ba81a14835e8c8"
  license "ISC"
  revision 1

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "81c3519afcb6dfc5bfa6a0a8a7c0e6f8118ab5a73573b5fcd388918b8f8a838c"
    sha256 arm64_tahoe:       "af3a5648a525cc249f5908f7457d63c75e03e42806b12c293d568368ebbf5571"
    sha256 arm64_sequoia:     "8058f100c31efd1383108fabe3e50946774ca65fac33dd365095c2ef0586adc0"
    sha256 arm64_linux:       "c60a8a86f3b0740e7222d63f891608ec0176035eface3f56581c58b4d068b560"
    sha256 x86_64_linux:      "746cf7771cc6fd587e6404df0ca4bfcc8d4e3242b2d853c22a07bab3a4557d45"
  end

  depends_on "pkgconf" => :build
  depends_on "libretls"
  depends_on "openssl@4"
  depends_on "rsync"

  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--with-rsync=#{formula_opt_bin("rsync")}/rsync",
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

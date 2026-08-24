class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-9.9.tar.gz"
  sha256 "24985845b7283b071942c9fa44598517461211ee32a690a219ba81a14835e8c8"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7bd007afbc2bdb471b22e548f5a6643f21e81119ebe499a055d4fe9128c53f00"
    sha256 arm64_sequoia: "1aafe492b3c9a121f681503b8011c271056c51970d3805a9f87e3d0afd65a0dc"
    sha256 arm64_sonoma:  "623a053b694a19af707c2c64b6f3b56bd3eabde27f6e75d0347396bf4d891bbb"
    sha256 sonoma:        "c041be5527f63848538fc50b86a63b7028338aefb3be3b2971b08ca53cec0578"
    sha256 arm64_linux:   "de736d06c33dff5db563efc17676512bcafa9b85167734b51331831e41f828de"
    sha256 x86_64_linux:  "508fc25958233fc0b29f0cfa1325cfe29d804055bc29b321bd643a5909a3becc"
  end

  depends_on "pkgconf" => :build
  depends_on "libretls"
  depends_on "openssl@3"
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

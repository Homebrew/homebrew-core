class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-9.0.tar.gz"
  sha256 "c364e38ba5501a36540521c1a76169dd9356e48dab941ae4147d155d2d55e12a"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c4270d290d79712df8741d40f951c5a8e4821c55617ed5bfbcc353cd9043055a"
    sha256 arm64_ventura:  "7447e09c8e99d9b7fd6cc6558688003dd91c28684d4404ff4d76e6299e0f7e4d"
    sha256 arm64_monterey: "240a4e16595400b7965dc80740298cdbbd2bed23d77c8e447446139916141c01"
    sha256 sonoma:         "c52a0d0a0911171c74961e0164378a361d84e397b1b061a084283a8d8cae3740"
    sha256 ventura:        "794670d49718efb46b96ae32dc124a311493fe8055b3ea941496f15c6de2ff7a"
    sha256 monterey:       "5512a4a3200a556538f2f952317cc07c4227c54f54bbdd9cdc7c78b4b27d2228"
    sha256 x86_64_linux:   "35b6f3c091016fde67bed1add82ace5b171626ba142ca3d4e3257982a34f858c"
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

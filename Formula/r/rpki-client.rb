class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-9.5.tar.gz"
  sha256 "daee7ee0d1c74ef3b44ad14fe6315a503919a49187379d2473299c28cb30be43"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "3b274b679a0868eff6a36bcb32cf53757f94acbf92b6bb77f377a4d3349d42b3"
    sha256 arm64_sonoma:  "8d6955d3e1a630fc49c7b75e7d3cb097f607bb07232b8ddea6d42d9f669dbd08"
    sha256 arm64_ventura: "65747361f8b7734b16ffccd2efefa7a273d5dfd8352a2bb2f1573b9387c9d7ae"
    sha256 sonoma:        "757b2720a4aa7e1cca84e95594db9a76cf04cd63ed1a929192180a2af0807245"
    sha256 ventura:       "87420aa9629f036f89904da817ffe0556117372a551142045ab8ee8ad6682d31"
    sha256 arm64_linux:   "f6345e6940184ac1074bf3caedbfa663f1af7aca0aef62423361880ae41dd5d8"
    sha256 x86_64_linux:  "2f9f591f37fea6e7ebb663d2f3efdc6bdf3cd297f16a0413ce2611f719f77784"
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

class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-9.7.tar.gz"
  sha256 "fdb3b36e8348a97bb9a37986755cdfc3331a47d2fd684f6814d23cdc63efc9ec"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "170f6d339af9d2f8626780f8857844a000002ac670e20c278f1772233404b283"
    sha256 arm64_sequoia: "b690b6ac953fb11a5e48342862db54a54cd6380bb7715ac6dae3bd66dd83ce11"
    sha256 arm64_sonoma:  "87be36de28526c452b70af913afdd9590ab4ad9ad1143192b3cfb6131d0626e1"
    sha256 sonoma:        "a90db0a3f3d587aafbec958d6ac70c1d2292feb3a29715e4e4efcaceeae5ad3b"
    sha256 arm64_linux:   "1c2fcfd7c269ea1c72228411476f159e7425700d2616c87321bc8cb6ce8cfe61"
    sha256 x86_64_linux:  "28b11db7413f349e91313a0297013efe736b5aac296f81b5d72601ce931d33f7"
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
    system "./configure", "--with-rsync=#{Formula["rsync"].opt_bin}/rsync",
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

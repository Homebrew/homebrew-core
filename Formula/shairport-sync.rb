class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.2.1.tar.gz"
  sha256 "1fe16856ec828704b086c571038a3b2eb907a3cf0a3847ed1b721b517554659d"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    sha256 "cbfaed8600347d959dbaed883fca89c6086aa5808c647014e5f63fcbec2fc43d" => :mojave
    sha256 "facc9f1d5d61ddf4779b1c531b392057d5143691af1ed5dc169dbe93fd6be6d6" => :high_sierra
    sha256 "bf4b79f69209e61d32b9427e072bca48f4089b7de849430b6576d936ba42bf1f" => :sierra
    sha256 "0bd51322cd1cbd3f2d875061b8382d223817e1bb5de89e8d10c4ff2c0ce2b870" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl"
  depends_on "popt"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-os=darwin
      --with-ssl=openssl
      --with-dns_sd
      --with-ao
      --with-stdout
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{etc}/shairport-sync
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V", 1)
    assert_match "OpenSSL-ao-stdout-pipe-soxr-metadata", output
  end
end

class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.2.2.tar.gz"
  sha256 "4f1ee142b887842727ae0c310e21c83ea2386518e841a25c7ddb015d08b54eba"
  revision 1
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    sha256 "7dc8276b51f1ef0ef4cf38c27228d46e80678425626783efc0e71646b8a6c60f" => :mojave
    sha256 "8ed5e98d394f2dc6136abbbc15ecdc27a471244ef2c67c69558fbf9c3fae77ed" => :high_sierra
    sha256 "72a828bd11b9c6a28d0c4b3c90e92ded0c4ee4ba5aa095f06a22362e5c78212d" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@1.1"
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

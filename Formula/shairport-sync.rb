class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.3.6.tar.gz"
  sha256 "a8382affd25c473fa38ead5690148c6c3902098f359f9c881eefe139e1f49f49"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    sha256 "9f5d751be1792a249b4c52d68ddca6e2680235f3e076902993aef5f916954b6b" => :catalina
    sha256 "c74ebdc84786fb9d1d07a079c34a96c30c6dcdfd315e7335bc0686b4c736291c" => :mojave
    sha256 "b905286034c6bf40d77b1267b4fd8eae1af2158e7b11c91e46d1ffbc43dcf65b" => :high_sierra
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
  depends_on "pulseaudio"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-os=darwin
      --with-libdaemon
      --with-ssl=openssl
      --with-dns_sd
      --with-ao
      --with-stdout
      --with-pa
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
    output = shell_output("#{bin}/shairport-sync -V")
    assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-metadata", output
  end
end

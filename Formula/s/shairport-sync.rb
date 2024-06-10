class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/4.3.3.tar.gz"
  sha256 "444bf77fe495d11d0c3b8212ea7a6ae44d6b2084c3600cea0629497a3e5f0209"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "67685f94de1f03d9082ad8808524f6913176d802c511c36fd1fbdbf6f03878d1"
    sha256 arm64_ventura:  "7fa48d3895cfb41036545b88f9c8ce45c86a54c8acceab91761ca23e75c8c7d1"
    sha256 arm64_monterey: "95ecc79f27214c47e6e6ea2403e9dfe5cd12337f5dfc792c9b33ec9d0b4d0b90"
    sha256 sonoma:         "042c9b5ed9ac077bdf5c2d0278a4f12f7a2e9921253f848573ce33286ac9c053"
    sha256 ventura:        "afa706f66261ec0e54349f21ec7d39962a503521601ece67a1b6ef965f52a774"
    sha256 monterey:       "d9b63ee30601cd727ca8cc4b80b425887a8ab63174244a3495bf02476cdcee9f"
    sha256 x86_64_linux:   "ea21b9774b19a6416e790a76cff0e5b5b8afe413e438b9819de20c1e78d9e093"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "pulseaudio"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-libdaemon
      --with-ssl=openssl
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
    if OS.mac?
      args << "--with-dns_sd" # Enable bonjour
      args << "--with-os=darwin"
    end
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  service do
    run [opt_bin/"shairport-sync", "--use-stderr", "--verbose"]
    keep_alive true
    log_path var/"log/shairport-sync.log"
    error_log_path var/"log/shairport-sync.log"
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V")
    if OS.mac?
      assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-metadata", output
    else
      assert_match "OpenSSL-ao-pa-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end

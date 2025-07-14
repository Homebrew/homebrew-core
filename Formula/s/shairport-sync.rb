class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/4.3.7.tar.gz"
  sha256 "a1242d100b61fe1fffbbf706e919ed51d6a341c9fb8293fb42046e32ae2b3338"
  license "MIT"
  revision 1
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "7545247fdb0c6f1d073bb20d3bc89304637ee0d57cee66e725e1ee32549dd1ae"
    sha256 arm64_sonoma:  "21a738ff972c71852726ef8073116fb6e77db042d92a4846b9aee123af0f5ff8"
    sha256 arm64_ventura: "1cb4522df509d78bc574c27a8d668b6bf639dcb0e6a68d015b8e93205c1c0ac3"
    sha256 sonoma:        "a61879e3ed9398bd9683ad8851d54db9c49a0bdf701cf5b58b6bc79f101ed553"
    sha256 ventura:       "eea7570e9fcc832b79f410bb906dac1fadb920deca94edb3d81f74544e48acb4"
    sha256 arm64_linux:   "69d9c8f3540f793214bbc3e9bbf61b39b5b4caa3bcd7c5c17a958ab7eb599164"
    sha256 x86_64_linux:  "5098428e618dec3360e3cb5ede3eaec09611ff3cc27596fc9a9fc2a737917bf5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "pulseaudio"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
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
    ]
    if OS.mac?
      args << "--with-dns_sd" # Enable bonjour
      args << "--with-os=darwin"
    end
    system "./configure", *args, *std_configure_args
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

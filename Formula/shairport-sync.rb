class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.3.9.tar.gz"
  sha256 "17990cb2620551caa07a1c3b371889e55803071eaada04e958c356547a7e1795"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "05049c6b445e6b5697a92a40969bff64f7b8b9d4da8c00464a245e6912c9c594"
    sha256 arm64_big_sur:  "bc1357912acf12b02c1ec752ceb7ca2a888f3d06b104e773c69d05b358d56e58"
    sha256 monterey:       "e4267faaffe1bad79c0d85a0b14de861be45db92e31d529dc07ca14ef76d5a68"
    sha256 big_sur:        "f6aee5b85a169e6b6356a4d9c79e961fd057ec9ed47e71dc1a0f2c39f3cc5308"
    sha256 catalina:       "516e9b4cba222f86f6aee6535840e4185c7c42c35926e881b994c35774be253c"
    sha256 x86_64_linux:   "4b82128bbe54f55e7a72d16ae694fd62d45bfc35d3382ed4c539cbb620ace2a0"
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

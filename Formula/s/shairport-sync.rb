class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/4.3.7.tar.gz"
  sha256 "a1242d100b61fe1fffbbf706e919ed51d6a341c9fb8293fb42046e32ae2b3338"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "c25646009fe8cddab1b71c91b10a39f911e97b3b3eecb86eb89abf5b06314e09"
    sha256 arm64_sonoma:  "35734a8d4528fa4adfda8389a9928ccdc0537fe2cc85c7d84a8fca56f2ad8f04"
    sha256 arm64_ventura: "8cf7de53d4ddb584a9c867487d12b63398c12a70828854856b356b89744bc5f5"
    sha256 sonoma:        "c354b7d9cbb4d7ae6f6c0eb45e90673033ed3a9f00fcc365aadb0126c03485e9"
    sha256 ventura:       "b926bdadaad35052db8c2b52c0d3c2f3a70b5029084e1f0f390525588e2a17bf"
    sha256 arm64_linux:   "371e002a675cc3343cbf7e9632b4d6b36cfe6c32465c3970fb22fecaa2f3dc2b"
    sha256 x86_64_linux:  "a11b5f33ab1cdf35b511fc944c61c192e9c070d58b09bcfb0b108388108208eb"
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

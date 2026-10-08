class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.5.2.tar.gz"
  sha256 "abcdb59674b6eedb4f3f6228f3c702e65d2cdc037231b0c48617fd90891b49e9"
  license "MIT"
  revision 1
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "ca485aa845f0ace913c96b738b163cfec02599168aba1f1db59df901b65a6f58"
    sha256 arm64_tahoe:       "36feac3b5b915d840388c62e691a03ce76efed097f679a09a1856ea8fe069164"
    sha256 arm64_sequoia:     "bf601a0a9329ce643f86ffe518aa743cbeee46ce1994c7d71aeb4c51dd68669b"
    sha256 arm64_linux:       "eabcee3a05fe35cd898275815818244f658dbec8c783b17e7c35ab7bd6559da2"
    sha256 x86_64_linux:      "035dacb2f4addfd76a3a18a44903f7c49f786c844bec821c909465dcee6df697"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@4"
  depends_on "popt"
  depends_on "pulseaudio"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    args = %W[
      --with-libdaemon
      --with-ssl=openssl
      --with-ao
      --with-stdout
      --with-pulseaudio
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{pkgetc}
    ]
    if OS.mac?
      args << "--with-dns_sd" # Enable bonjour
      args << "--with-os=darwin"
    end
    system "./configure", *args, *std_configure_args
    system "make", "install"

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
      assert_match "libdaemon-OpenSSL-dns_sd-ao-PulseAudio-stdout-pipe-soxr-metadata", output
    else
      assert_match "OpenSSL-ao-PulseAudio-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end

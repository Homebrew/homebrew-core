class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.5.2.tar.gz"
  sha256 "abcdb59674b6eedb4f3f6228f3c702e65d2cdc037231b0c48617fd90891b49e9"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "1757c4a2e14289fc5a91ee9cab7f587db955857cf6765ea391458fd82aa4cf14"
    sha256 arm64_tahoe:       "c0dac3881395136f1393a1a3bd8831ca9dab23aab11f894ed65a49bf40f4e1b5"
    sha256 arm64_sequoia:     "fd1b9ed19cd116f4b1fe5d60c7b511797ebfa8935fdd6268af7c3684de2e2a84"
    sha256 arm64_linux:       "f431591a6c3fdc775c13ca0ef7ee8917d4d24bf9c41ebd5c5cd6a5de55c8207e"
    sha256 x86_64_linux:      "86ea8189c3cfd0507d85e68b5ca8c290ebd8b12156ac96114df0a45ed57e517c"
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

class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.0.tar.gz"
  sha256 "ace8e2c771f9c30e55f1a5e8b2b180b09fe29133e6ed1738032a6a7c3f74b22d"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "20fbec8aa6e6d5b713a377c3609de2ed0860d30a0a126598b6be3696463c1e49"
    sha256 arm64_sequoia: "6e40bc310297cef3e8fcab70f6bde1f6d9dbd1da7f346ca459fb5fc98ad459dc"
    sha256 arm64_sonoma:  "c6d800e9669423a2d9d63cca45466e12121bb4d70c6b874a9d1a2da94086f045"
    sha256 sonoma:        "7a4c5469ec054322ab683f563173ee14afc9d53908c1be5becda721db8038229"
    sha256 arm64_linux:   "9c85eef3917aa731f4db35e6e43e681efec6908820d571199c38c010e1200b21"
    sha256 x86_64_linux:  "d11973583dc6929bd4b28a3f2619b7ffdb207210036c757070ed67b8b6315854"
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

  # patch to fix version string from 5.0rc0 to 5.0, upstream pr ref, https://github.com/mikebrady/shairport-sync/pull/2144
  patch do
    url "https://github.com/mikebrady/shairport-sync/commit/6c71105e98af30a9b157a1534d0bed82f4e49de6.patch?full_index=1"
    sha256 "67edc2bcb8b37a1fffacf7499d42c8abfe44a7af0312f7407f056b677d7681db"
  end

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

class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.0.2.tar.gz"
  sha256 "1fe2394d2ded30017ca1038a46d4261b4983d94d98b8dadc7bca64431b27bd08"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "100c7c7245317c1bd2001b86fd14f55d67cbe39005fc0a085e235a5746f17a73"
    sha256 arm64_sequoia: "6e5a3b57c7a640cb4cdccd345e78babe2a072ecd984b509fee9e6907b528e086"
    sha256 arm64_sonoma:  "7cb0284ee2fcb64966525c6ac9ec73bf266d149fdf165908c42854746e4eaf17"
    sha256 sonoma:        "7f5ae7695e28e83617327577a64ee4bbd281175525b6dc3a88be7123e5ce78a7"
    sha256 arm64_linux:   "7b785dc908b01f750c209371c0aa154473f701802778533da2cad3c4dd601fd6"
    sha256 x86_64_linux:  "eb7e702e7dcce7411e448f6b9336aceb71f49fd5e7895d50cac12df03e774dfc"
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

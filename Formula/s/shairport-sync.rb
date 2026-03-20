class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.0.1.tar.gz"
  sha256 "ca963550c488c8d0cd39b7f1b58a1534fd916c1c66ab6b70a1115e92855deb0e"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "59e7a2c28373a68e3da74202f8958c0990475adfa2e1e12207c0f451af45f0d2"
    sha256 arm64_sequoia: "4ae7e20e15ce356fb061b708e4d90ef52b83903423f6a9c5e5fb8cb22dfa5c85"
    sha256 arm64_sonoma:  "fff56b64927146f8afdaa9c8adecf304492a52b1d5ddf1c87b5b16757f0fe7d3"
    sha256 sonoma:        "2e056fb4c948a62bbc4c1ebf054c1b24b0119e761b9e9882a16df001f8032238"
    sha256 arm64_linux:   "62c37ce7d78d4ee09da3df19b742bf91c598b049d76af153ff6492c550a6f57d"
    sha256 x86_64_linux:  "642c93e77e6e39a49a02a4c02b09ea8cc70ce3a7d5d177f67941eb6635679427"
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

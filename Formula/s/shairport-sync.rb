class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.6.3.tar.gz"
  sha256 "670f9cefdb9c2d70f7df71890e63ab0a31d08a815dd0734245d935bfd01e766e"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "c4b0cb8134e0d2159d6c78b24b1e487d3b895c98c84a627e204bf15a920cbc45"
    sha256 arm64_tahoe:       "4110ab7bc8738cd3b345ca78971a016c38709f02251b1213f6b2ab64a4f68370"
    sha256 arm64_sequoia:     "34b380138b158ad2fbc1c4337b3756ffec9b56d9a239f3657e3116f442cc6cc1"
    sha256 arm64_linux:       "da88a44c4f1cb90790522fb9f6e01547f82fb12c3c87a69262afff968ec2714e"
    sha256 x86_64_linux:      "b13b9aee250428c959a87c7ed16554f291e430b8feb141b2e1b05b20f7d8ef59"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@4"
  depends_on "popt"
  depends_on "pulseaudio"

  deny_network_access!

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

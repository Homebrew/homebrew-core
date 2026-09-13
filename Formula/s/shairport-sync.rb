class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.5.1.tar.gz"
  sha256 "5f56571f11206cb29e1a319df10c9b1b1df21dc9e6800a3b9aa701d17aa1046f"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "8de312cdc5cc285339cbc8b77cf6cee91bd8353723e8f6c2ea3f250ef6f0c685"
    sha256 arm64_tahoe:       "b7239131cdaa1eae191e2de580f02f2533da7464df8620178fd9f7bc53fa7458"
    sha256 arm64_sequoia:     "2da87a1e0b74baed7104dfdcb8dca8a4dfe8f748794f22689be08d6c9471a3a5"
    sha256 arm64_sonoma:      "e5d4638b9f2b6455379346f5babc6305fbb8400c3d764b07ee7d52e333fc2b61"
    sha256 arm64_linux:       "2c540ddcd91720d87fae4d53f383c99f5559a1dc5cf884dd4e2a5aaab61a6ebf"
    sha256 x86_64_linux:      "d5ca521591260a026c99c3d8b0ef23d297daf1ed03e78146be6878abaab813d9"
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

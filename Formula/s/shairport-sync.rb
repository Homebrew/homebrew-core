class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.1.tar.gz"
  sha256 "d85b5ad26449f3777518c4bfafeff0e4a6ebfb8333187df0ef462c199a4aba83"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "a38b6532997da8719f6699c39b65a5c5bacbb756aa45587a4896edaac32f111f"
    sha256 arm64_sequoia: "7199f1ee3e8e0b93e94e658dfa6d5df7a9b90ade320935e6830a932ecfeb3fdb"
    sha256 arm64_sonoma:  "9d9a7d30297004b7fb858086a8560032c2e4cd20c357387dcfb7f97eab0a2e11"
    sha256 sonoma:        "53e8476e0234b7279a3d9fcfa55a5508c6c6030c558f63ebf69d5e3cfb8976df"
    sha256 arm64_linux:   "0dc347bd5f18a77923824cca02e3ae1e404f7d321fa601cad7c55c1629a4250e"
    sha256 x86_64_linux:  "b40d8c4214a49eaa4256226425a4ed02b955dab1740b86f2ada3eccc446bace1"
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

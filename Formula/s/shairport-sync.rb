class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.0.3.tar.gz"
  sha256 "747f5b472ff937515238c4004ea4b6e308d1c6b055aa2712bf17aca0530dbe3f"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "92fa8ba7a5da6cbd5ba7cd6b6b68b5910d5e8927d0e5a8daadd04b9e5cf3171d"
    sha256 arm64_sequoia: "a14a768a218935fab3e391e1f5e27acc85cf0410d84ee4439a74b40021c28c24"
    sha256 arm64_sonoma:  "041edb48fecbf5263a748fb17aa979defea43f738859046dbc5fb4c3677c3b4a"
    sha256 sonoma:        "9cc6c4b9edc5eb522e3204eb0a78f74dc7ba62edfbcf02c36bd16026677911c2"
    sha256 arm64_linux:   "6700c445cd03e1237248f2088eff7dbd4eb70eb6211444f0e09ec4604713ea9b"
    sha256 x86_64_linux:  "36b47b6d7f5b8f1cd6df282a733e4ebbdd31560770f6f923f165d1ca559349ea"
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

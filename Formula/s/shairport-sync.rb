class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.0.4.tar.gz"
  sha256 "b89d4af74cffadd83d1be6eaf4e967180aa5a6aed32f561c937ae1d787909c25"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "8c8ccb8d9fb51f9160da541e850b9e5195c3b6a1da60c442d78a80cae3b8499f"
    sha256 arm64_sequoia: "ce38e22815199ae1b92446c359d3e562a8d5935c2b4006a31c85e1cabaa0b5bf"
    sha256 arm64_sonoma:  "a8095459cf5de8d607394ced5d8cffffd14c909d705131d4648d9305b396bbbe"
    sha256 sonoma:        "cf1d2b5d1fc55570c06b7ff063b5c5f38f4ea95b4686960d5bdb9a8306945b06"
    sha256 arm64_linux:   "5375c5044c5860d0727557f7477d1ce1fcc25ff0abccd19b688382de9ca2a377"
    sha256 x86_64_linux:  "1bc460766fa97a4f5fdc0fe2cc70bab83d6ada4a2dea089d447d3e5e4c68597c"
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

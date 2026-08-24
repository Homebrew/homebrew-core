class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.2.2.tar.gz"
  sha256 "068041f65aeb303ae24a90350c2b011b8f282d50e7335135586ee47eab9aed51"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "348316967b6bbafccafd902855fafbc1eb32aa2c00b0e8fe74db1e153e6853ea"
    sha256 arm64_sequoia: "3fec605e437b8d5c31bda06ea9c60e081d2138978297f68c1acbe5600958c5ad"
    sha256 arm64_sonoma:  "5b553644e75cbd9e857b475547acbea3da7711546e5e9a6219d86d263184a57a"
    sha256 sonoma:        "47e62a7ac0f01ecb5b8944aac07b32751faafc6a92f89e812b198bcc0ad5a29e"
    sha256 arm64_linux:   "2a555c4d7256f8bcfdc9dd05a683b89b545e59b385fd4e9eddf71d4eb79c2727"
    sha256 x86_64_linux:  "d7e72476b1b0500de889be1a2a6649113b37a3e7e22616936108d61e727ea699"
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

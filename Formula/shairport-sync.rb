class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.3.8.tar.gz"
  sha256 "c92f9a2d86dd1138673abc66e0010c94412ad6a46da8f36c3d538f4fa6b9faca"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 arm64_big_sur: "5ba3c8e5edb375fc0704715f2af591a95bccc371d30f19d6af77b27069de80c5"
    sha256 big_sur:       "f901fdd19cf7effc603519cc071703014c52264434d6da2eac51da37323a12ce"
    sha256 catalina:      "f7e414e4106c07a4ec3db03f1d0219280d47eedbef5c65f30ac3c488e5978cd4"
    sha256 mojave:        "7258fbd051a45b0fd5524b1017c6435be4471c4ccaef63b4c733c2ed2efb31ac"
    sha256 x86_64_linux:  "0502a7c91fe4f656ce22633c52de830d1f7a783b31af0740234f808d0ce16dde"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "pulseaudio"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-libdaemon
      --with-ssl=openssl
      --with-ao
      --with-stdout
      --with-pa
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{etc}/shairport-sync
      --prefix=#{prefix}
    ]
    if OS.mac?
      args << "--with-dns_sd" # Enable bonjour
      args << "--with-os=darwin"
    end
    system "./configure", *args
    system "make", "install"
  end

  def post_install
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
    on_macos do
      assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-metadata", output
    end
    on_linux do
      assert_match "OpenSSL-ao-pa-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end

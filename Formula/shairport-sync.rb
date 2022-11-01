class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/4.1.tar.gz"
  sha256 "951fc9f33a631736fe49d2ed040b27a417c93ffdf05a2d13116c6dda7628ea86"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "99c9ba0682a45d3e6f4284dd6668e821a906739f03f3c39e6fbbf104e76a4f6d"
    sha256 arm64_big_sur:  "e4bd13797604863009acbe319d8250f2d8aca37836470ced7558af2526ef29de"
    sha256 monterey:       "117f047708faea0c9592fe3b7dde5adf16737ba2c79bfb236dbb498528e68a33"
    sha256 big_sur:        "8cc299dfaf1e33c3d5068f5679a5ebb15e86949c79ba393436228d9cea1cc2e7"
    sha256 catalina:       "894fc1015d0b7398656745aa695082e7f5ece775fc727cebc36718365e6dc80a"
    sha256 x86_64_linux:   "fd5ef974569026717ff24a9533d39334f333968c25cd6831336deb113be17000"
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
    if OS.mac?
      assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-metadata", output
    else
      assert_match "OpenSSL-ao-pa-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end

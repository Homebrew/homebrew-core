class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/4.2.tar.gz"
  sha256 "649d95eede8b9284b2e8b9c97d18c1c64cffae0a6c75bc4f03e3ae494a3e25b6"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "10902fdcd0c2e74bc13695748c7f087630219e9ee1ca41f9631201102a07fee7"
    sha256 arm64_monterey: "c1b199585c9f43044e3c6795d01d2465a4b1a769257e298d8e5bb7d4ffd4ad54"
    sha256 arm64_big_sur:  "955c2f30e7d81645fdd85eab9ca811ffd8150889430891127a193d5555da81ee"
    sha256 ventura:        "80369077d79dcf9978d7b74eaf64539e698c1c2359aa09e1dd6e216ed9086494"
    sha256 monterey:       "c2902684373f65bc618aa3fbdd632c6803f6aa316e91dc8ea31e0e1f71878502"
    sha256 big_sur:        "5ccd47b1cbd87e9209ae3ff1e2494932bc23784ea10a13570593a3f173ba3c07"
    sha256 x86_64_linux:   "adce7a83286b69ce53d26fca7dc07290c4cc98dcb64d9e876dd029b379605011"
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

class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/4.3.4.tar.gz"
  sha256 "3173cc54d06f6186a04509947697b56c7eac09c48153d7dea5f702042620a2df"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "d9b6b11867be65a4177595aaf8583bf66c11d61f4c595a122546b324ea0f88d7"
    sha256 arm64_sonoma:   "3ac27bf42aa216391c1f1b2c05a5e322b032e4f2f2cff51efe5447755c5027e3"
    sha256 arm64_ventura:  "77c18154023144ff4789edbffa7d1e6e168ad1ffc40d00ee9937fbdced36aae9"
    sha256 arm64_monterey: "7987d05e9b78cf528a84f37aa79c0d9853311510e8c172c66bd851e708642960"
    sha256 sonoma:         "e9dbf27608fafad55da29029d02e4f7e214a81e1a4820555c41c4e2fae26e887"
    sha256 ventura:        "5f3f0bb020de0b5c5f12ad9a6c979cdcb7ffbf742358d27c6961afcaac5aa6fe"
    sha256 monterey:       "45fdb0ec804521006e50ec1682a20434cadb042842d53a41f07e9f9e7f88dd8b"
    sha256 x86_64_linux:   "828edfc5d9301bfec852f6d387ef6080201643edb3c4b60d12d5202581cfbc87"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@3"
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

class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/4.1.1.tar.gz"
  sha256 "e55caad73dcd36341baf8947cf5e0923997370366d6caf3dd917b345089c4a20"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "6ff70dfe1992fdb1c1a9ef56e28bf3b7c617389ee087c07e5b861d7975ac5e5e"
    sha256 arm64_monterey: "a18905be175c04339d2fbe01fe00cfb2b3b5931441926234300dcf6b905ab2aa"
    sha256 arm64_big_sur:  "80028550e6e29479135e401e3b1fdd99f48ad3f44cb19e742103ee50531551fc"
    sha256 ventura:        "0a6d125808d72050f8d8553f8945b4c5d7d1b90dfbb3b012829e5e3923037b53"
    sha256 monterey:       "07c4d048df9e23310c545964fb357f69d36b90d480e17ae6932708dce6aea033"
    sha256 big_sur:        "adcfc2ec5df8b56e735df377512307a54b830dc83e5cba5d583cb54f554be6d0"
    sha256 x86_64_linux:   "78f8f67b82b58f6499f250a163cc09a5b086420fea0c4b9409b713dd11406aa5"
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

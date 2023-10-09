class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/4.3.1.tar.gz"
  sha256 "9a0044eb7c940dc8dba42de90439386929926b83f821b916db03bc308fdaf189"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "9724172b5010252928b283857fc82b008aa09f9c3d0a0405ef4caef20c495d51"
    sha256 arm64_ventura:  "395e548f70d74ce527521bf81f1c2c3c9c4218dc8418900144b6035020033654"
    sha256 arm64_monterey: "356dc1fd2cbb0221498c78d1b7fc9571071b07e766420f21d06bb5f3d9c08270"
    sha256 arm64_big_sur:  "26fc233ac20725b95a9a71363d24e7b33ae99fe5f65fff70ebc8f759ec205164"
    sha256 sonoma:         "7478b102607850e628dda5cf50d9e91db3b682732374f172c689acfcf225a2a9"
    sha256 ventura:        "b8157c97cc8a9e77b8e3a96a6382a9136d0fcb63dc8b80b7b1baf39f93ee59f2"
    sha256 monterey:       "d60c8c7d19d6bb11bec2796413665a45b62a1dcb0476486b0b6ded5fdb08afbc"
    sha256 big_sur:        "7f3f60c24cc19201f61664b6e8b02e409db6e6276f2b1fb09bf2194c20e83031"
    sha256 x86_64_linux:   "d98553f2430fe8e4e7d7aac8d2df3b2cb115c174435fd178a5172c3c95289901"
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

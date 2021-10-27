class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission-releases/raw/d5ccf14/transmission-3.00.tar.xz"
  sha256 "9144652fe742f7f7dd6657716e378da60b751aaeda8bef8344b3eefc4db255f2"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://github.com/transmission/transmission-releases/"
    strategy :page_match
    regex(/href=.*?transmission[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "7cea8d14774f036fb808ab778efd7aaebfdd46b0057e401ccfc1744e09f05e30"
    sha256 arm64_big_sur:  "07a84ee48fdee3046614731074c3e3f20f814011d644e6804a836e586a11f4a5"
    sha256 monterey:       "8785d5cd7675a2f5203cd9cb4a7b13b756037d2ee127abfe6223b946733efe34"
    sha256 big_sur:        "d536f415cf27818d83062e693c8ebde50057fbe36d120b81cda3bbb32e5396b7"
    sha256 catalina:       "7640fdff8a0840356ea2d43d3ab0efe1d5da5c2840d9fe555deed3c9957705c1"
    sha256 mojave:         "db2aa6896d89884e15d5dda0b35c152a96cd028703c69f7f8bd9288d0d61a838"
    sha256 x86_64_linux:   "178d05964e9efd8d4541cf5589f4772ccdc59b8de83158f96b8ad7ffeff6b8d2"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    if OS.mac?
      ENV.append "LDFLAGS", "-framework Foundation -prebind"
      ENV.append "LDFLAGS", "-liconv"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-mac
      --disable-nls
      --without-gtk
    ]

    system "./configure", *args
    system "make", "install"

    (var/"transmission").mkpath
  end

  def caveats
    <<~EOS
      This formula only installs the command line utilities.

      Transmission.app can be downloaded directly from the website:
        https://www.transmissionbt.com/

      Alternatively, install with Homebrew Cask:
        brew install --cask transmission
    EOS
  end

  service do
    run [opt_bin/"transmission-daemon", "--foreground", "--config-dir", var/"transmission/", "--log-info",
         "--logfile", var/"transmission/transmission-daemon.log"]
    keep_alive true
  end

  test do
    system "#{bin}/transmission-create", "-o", "#{testpath}/test.mp3.torrent", test_fixtures("test.mp3")
    assert_match(/^magnet:/, shell_output("#{bin}/transmission-show -m #{testpath}/test.mp3.torrent"))
  end
end

class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v5/squid-5.9.tar.xz"
  sha256 "3fe5c2007da2757446af91b6ef974f154b208120a9a39396ea681e5c4abb04b5"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.squid-cache.org/Versions/v5/"
    regex(/href=.*?squid[._-]v?(\d+(?:\.\d+)+)-RELEASENOTES\.html/i)
  end

  bottle do
    sha256 arm64_ventura:  "cbbdf13ee2098c32baa9bfe690f1446fbee226bf5cf0c80868a0698b467c3aa1"
    sha256 arm64_monterey: "3537c064875681dcb687f279bd35913ce722d2fb6703fe1ebc7982aa1576bffc"
    sha256 arm64_big_sur:  "ef839dc315ae730bc6fb368c9737cc93d3ad5b94ac7a9bc52718eee367024d60"
    sha256 ventura:        "0c3919881cbdff7c75ceec04d543f600f2202a7c937f97834f0d7ce3268a65ec"
    sha256 monterey:       "da56d1913c356397fad87e2985f431c328aab8505a4a3c23bd3963b21b4bb12f"
    sha256 big_sur:        "bf89451bfc3a8e21874bccc31554c74a9268d829dbe4056eab2bdea12025c5a8"
    sha256 x86_64_linux:   "d01a8a7022a0e077201d9e433224092f726834cdb1923d051c29b902dffe706a"
  end

  head do
    url "lp:squid", using: :bzr

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  def install
    # https://stackoverflow.com/questions/20910109/building-squid-cache-on-os-x-mavericks
    ENV.append "LDFLAGS", "-lresolv"

    # For --disable-eui, see:
    # http://www.squid-cache.org/mail-archive/squid-users/201304/0040.html
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --enable-ssl
      --enable-ssl-crtd
      --disable-eui
      --enable-pf-transparent
      --with-included-ltdl
      --with-openssl
      --enable-delay-pools
      --enable-disk-io=yes
      --enable-removal-policies=yes
      --enable-storeio=yes
    ]

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run [opt_sbin/"squid", "-N", "-d 1"]
    keep_alive true
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/squid -v")

    pid = fork do
      exec "#{sbin}/squid"
    end
    sleep 2

    begin
      system "#{sbin}/squid", "-k", "check"
    ensure
      exec "#{sbin}/squid -k interrupt"
      Process.wait(pid)
    end
  end
end

class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v5/squid-5.8.tar.xz"
  sha256 "7e969f8c8df569cb8646d67ee59fdbf2627beada12954c301e7c1a9c1c11734f"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.squid-cache.org/Versions/v5/"
    regex(/href=.*?squid[._-]v?(\d+(?:\.\d+)+)-RELEASENOTES\.html/i)
  end

  bottle do
    sha256 arm64_ventura:  "4055c20d741958a157aec8846516aa352b80b6af08eafad25fbac1b8ecb8b2e2"
    sha256 arm64_monterey: "f949eb084b34afa9beaa39c8d93fbb9234c5e18541e3db104a3f7fd15104df69"
    sha256 arm64_big_sur:  "9302c53aff654b7e27e2fac87e1e7b1c7ca792fa339c2fe3a0799fdd767907ee"
    sha256 ventura:        "876f081a7f3cc81084988bf0b27ae10331ee934887bfa8cbb0e36d7d6db63f3d"
    sha256 monterey:       "a283cbfea3d2ab52cd607ec70d937fc80fb772a5321c1c638562194ed7007d48"
    sha256 big_sur:        "8f1cc7210e7930f433179c7f4e3eb9f720a5ed8b7815df3b96191b2243efcf49"
    sha256 x86_64_linux:   "c00d541660b88687907de054902bc068cd11186277bea426345b7d2f9a78f830"
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

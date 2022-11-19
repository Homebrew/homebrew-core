class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v5/squid-5.7.tar.xz"
  sha256 "6b0753aaba4c9c4efd333e67124caecf7ad6cc2d38581f19d2f0321f5b7ecd81"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.squid-cache.org/Versions/v5/"
    regex(/href=.*?squid[._-]v?(\d+(?:\.\d+)+)-RELEASENOTES\.html/i)
  end

  bottle do
    sha256 arm64_ventura:  "f46c29e3422bd688e271f2e3156ad2ef2ae7d4f5c011801344e109ab9a425998"
    sha256 arm64_monterey: "2fd285014a9d8b23db15573c51d9ba2bf3a7980aa42d1c3232799db5d7ec5383"
    sha256 arm64_big_sur:  "468a3787a8beef9d643d2f602e0a61844a2bc5c5c0d9a5295e9cee103e95014c"
    sha256 ventura:        "e4d5cff2f11e0025525876ad7f5b613738d396369d3be734e9cd6c00e72fd295"
    sha256 monterey:       "4f4c35109d3f98579fea0e0176010b8e9a20b6c8bf20ac39bc1fab8603886876"
    sha256 big_sur:        "69034d739bcf8ac981393dc1e6d8153fac7b3a1606aa0779e6416186c9ab8346"
    sha256 catalina:       "2e36981ce834fbe8cdb59983c58533daf023cbaca7329bb6f8c0b24e3544b5ef"
    sha256 x86_64_linux:   "e950bb9356faae896c283a810fd284beb277fc89723f08c7cc022f08b04e8a72"
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

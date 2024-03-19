class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v6/squid-6.8.tar.xz"
  sha256 "11cc5650b51809d99483ccfae24744a2e51cd16199f5ff0c917e84fce695870f"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.squid-cache.org/Versions/"
    regex(%r{<td>\s*v?(\d+(?:\.\d+)+)\s*</td>}im)
  end

  bottle do
    sha256 arm64_sonoma:   "5fd7eac7fbf10dd91c7161eb57b35f71a2511b53d05f9f5380bc485883e55150"
    sha256 arm64_ventura:  "d567ed02192b994105d7d1c1cbeaefee19b95ff7a23d75d69cabc4a935505ae4"
    sha256 arm64_monterey: "cf4b27495b3d5d589e5cfba44f6fa1009fc8fb6c06cac84871f24819036465ab"
    sha256 sonoma:         "7d90b87e4263093e099bfe39d5979a0040ef6db3795bea299ce7e71911de769f"
    sha256 ventura:        "d5cd21426193381d90b1c3f6cd6ead284dc8d1798082f4a1ac3633494b31db60"
    sha256 monterey:       "34844c6cb2061d90f96cec9a1b756a9289ff2376673c95159e61db1813e0e4d8"
    sha256 x86_64_linux:   "1c16535a90df2c9ad674a4de890c6a87cff31e4c35af58dfe99153d17f2da7f3"
  end

  head do
    url "git://git.launchpad.net/squid", branch: "v6"

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
      --with-gnutls=no
      --with-nettle=no
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

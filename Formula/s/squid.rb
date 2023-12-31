class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v6/squid-6.6.tar.xz"
  sha256 "55bd7f9f4898153161ea1228998acb551bf840832b9e5b90fc8ecd2942420318"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.squid-cache.org/Versions/"
    regex(%r{<td>\s*v?(\d+(?:\.\d+)+)\s*</td>}im)
  end

  bottle do
    sha256 arm64_sonoma:   "b12ed8090e0582544549a48673dbf147d2746a52a0ea79018511458907d670ad"
    sha256 arm64_ventura:  "28c062a504ca1d38a1bc173c02c8832e8398ff9c06474b118eefdd11c22209dc"
    sha256 arm64_monterey: "6804c3e84f088570c3b6ad43413ff030325594f4c891a62511a2f5487aedd37a"
    sha256 sonoma:         "217b1a513d74c0611c437b7c0e233b6741696b53ca8ed581706da2ea95e9ce2b"
    sha256 ventura:        "334ac221dc1346a00c8c70b6764bb5f49822018c9c88ce5e978562c9eab2b8a9"
    sha256 monterey:       "8e1155bae6376caf9dd8c0e9d23d25c9e5e0f73f5cccfe1c3a78f1c6ac12a761"
    sha256 x86_64_linux:   "6bc98e276cd40a4404fc0e2fc81c4ceca5db2873e5a638ca8a5adf7a759ea4e8"
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

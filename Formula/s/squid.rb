class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v6/squid-6.7.tar.xz"
  sha256 "0f701e1369bffab9ca348075fbb96eeba2f0e778382b0331e5c8f6541db6a42d"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.squid-cache.org/Versions/"
    regex(%r{<td>\s*v?(\d+(?:\.\d+)+)\s*</td>}im)
  end

  bottle do
    sha256 arm64_sonoma:   "62de06cd26955c809fd5c2e3f4ff8c6aa7cdcd662d3b995ef78c37aecd3d3fef"
    sha256 arm64_ventura:  "b186a43474d5872f756ccce9016751e1edf9ad3aad564c8e550edc7a403ed7cf"
    sha256 arm64_monterey: "efa7e71770750238d930f213593183bfcf3e1929d3147e49e4704ef7daadb8a3"
    sha256 sonoma:         "97d8d389005c770495ecd90ece22b3e3146add13dc24e73cca26e2c30476bb64"
    sha256 ventura:        "93b30487f942f1bd88c2ba6a28788023c8d28c91642f391392e2119ac372b134"
    sha256 monterey:       "b6ad3f3970de49ba0c3c5bd65cd62830fdf5ba93afbd9ca14ee86c83d80c91aa"
    sha256 x86_64_linux:   "081f87399d0060e54cb3b73b517bc7677fa64101d42b8169e29bb7a8dbeb9329"
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

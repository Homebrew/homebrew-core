class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v6/squid-6.9.tar.xz"
  sha256 "1ad72d46e1cb556e9561214f0fb181adb87c7c47927ef69bc8acd68a03f61882"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.squid-cache.org/Versions/"
    regex(%r{<td>\s*v?(\d+(?:\.\d+)+)\s*</td>}im)
  end

  bottle do
    sha256 arm64_sonoma:   "a73d641e0e9bb8d149c2d23c4c6f38c9bb7cf1315d762042f83267bbb0cb719d"
    sha256 arm64_ventura:  "30b331f2a8ef39eb3580c1dd46ae720ad770fb53e5aea64e07514d8b2a8b3202"
    sha256 arm64_monterey: "d492e5e10a879cd440d469ed6e46d8289766084c3470b3fc6662d3c4eb0d43f8"
    sha256 sonoma:         "12726d3dd7ecff433c72cf652d25762cc5fab16ddeed9107c111ad1ca6af25fb"
    sha256 ventura:        "1024d2fbfba1f35b16dbc79c3158117e8763a583a1d2e874096a6b72f3c013e2"
    sha256 monterey:       "3bdb9cb9dd07ab21403e981655310c450c1c2e5e97d8688d21ca394c3a6fa2bc"
    sha256 x86_64_linux:   "4f729afc0ec841b97f653ef11a83105f65bb50810bba11c3ed0f0807bd1200d4"
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

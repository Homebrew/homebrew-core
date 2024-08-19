class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "https://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v6/squid-6.10.tar.xz"
  sha256 "0b07b187e723f04770dd25beb89aec12030a158696aa8892d87c8b26853408a7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.squid-cache.org/Versions/"
    regex(%r{<td>\s*v?(\d+(?:\.\d+)+)\s*</td>}im)
  end

  bottle do
    sha256 arm64_sonoma:   "5fa3257ed486860e511c8c10bc056460b8419fb5d7ba2c6f743bfeea940c71ea"
    sha256 arm64_ventura:  "1e7ce0bc5a2e0d556a4ca44634eb163eec97ef6c53906eff3898ea8f516df905"
    sha256 arm64_monterey: "e534196b8b3a6f783c1e051835ee65f57f9c9419a0b994437aa15996b8f7f529"
    sha256 sonoma:         "843721b45aee230d3910da38cf6ec30eaa8c48ec17349f1b5c6e36ba63eb69af"
    sha256 ventura:        "7752ea790e98ff24ed7b14914ec94ee6728c5f5fd13259e355c8c8b9a78171b0"
    sha256 monterey:       "7c5d623e58d37b2b0592efd73f1508f90ab2c31edae464084f515793499c0be3"
    sha256 x86_64_linux:   "600fc85cde06b51d39410e597f770f9574089fd9ede69657cb31f3d41cc985e5"
  end

  head do
    url "https://git.launchpad.net/squid", using: :git, branch: "v6"

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
    # https://www.squid-cache.org/mail-archive/squid-users/201304/0040.html
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
    log_path var/"log/squid.log"
    error_log_path var/"log/squid.log"
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

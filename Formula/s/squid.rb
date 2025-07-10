class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "https://www.squid-cache.org/"
  url "https://github.com/squid-cache/squid/releases/download/SQUID_7_1/squid-7.1.tar.bz2"
  sha256 "77e81d107a8fc10ec08f2bc36b38c9aa3d49cfdfab3270d67e001028aa6d8a2a"
  license "GPL-2.0-or-later"

  # The Git repository contains tags for a higher major version that isn't the
  # current release series yet, so we check the latest GitHub release instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_sequoia: "fc55d5b5f7193e494077acfaf9da79163f44962d8f24d7bdaa739e0201378768"
    sha256 arm64_sonoma:  "ce666362fc3920145ec84d9531254bc9fb1a92b508e50f2abcd165b6e369b288"
    sha256 arm64_ventura: "12f9597158777fbb661390e7adc0897fa6e612ea29b6ba2d215b0f02ac970f4b"
    sha256 sonoma:        "55798358539c094cdc9f98ab32bc98242a91f6b213be524984d5e2a6b1ee34ac"
    sha256 ventura:       "e25267b441e7cf447735c507cebe1823dbf59d7877cfa59016e0a27bb44300ec"
    sha256 arm64_linux:   "31831d1691b5620c39eab2792efc21ced6727a03964701853de1ca2513dff5f5"
    sha256 x86_64_linux:  "706caba4460341801429861d75907f45be7d6bf01240715b7388753ce4ab3ad3"
  end

  head do
    url "https://github.com/squid-cache/squid.git", branch: "v6"

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
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --enable-ssl
      --enable-ssl-crtd
      --disable-eui
      --with-included-ltdl
      --with-gnutls=no
      --with-nettle=no
      --with-openssl
      --enable-delay-pools
      --enable-disk-io=yes
      --enable-removal-policies=yes
      --enable-storeio=yes
    ]

    args << "--enable-pf-transparent" if OS.mac?

    system "./bootstrap.sh" if build.head?
    system "./configure", *args, *std_configure_args
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

class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "https://www.squid-cache.org/"
  url "https://github.com/squid-cache/squid/releases/download/SQUID_7_3/squid-7.3.tar.bz2"
  sha256 "af7d61cfe8e65a814491e974d3011e5349a208603f406ec069e70be977948437"
  license "GPL-2.0-or-later"

  # The Git repository contains tags for a higher major version that isn't the
  # current release series yet, so we check the latest GitHub release instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "9bbca04a45b49503c0f9b936aab993fd17a00213a4e76649ec5ddc2316042922"
    sha256 arm64_sequoia: "49501db2c4b7921131f37025d26513dec1ba817407184a61a077dff8c8310143"
    sha256 arm64_sonoma:  "1faee147f4720de4c88fec34f73fb4e1468c8f24794ef893eada83c0d33ae090"
    sha256 sonoma:        "b57c7f8e1a09663f5b560c9e41b797107932bf9918a850cfd6280ce7a260f8fa"
    sha256 arm64_linux:   "2e61d953c90f9093df8db0a5f1f3289955ea9212194948cbc081d4a8a6fb2670"
    sha256 x86_64_linux:  "ce7f04ed768aaf3696bba47d0062e1a828ae4ebe550b5f88487c0e70aa0d1687"
  end

  head do
    url "https://github.com/squid-cache/squid.git", branch: "master"

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

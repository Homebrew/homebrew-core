class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "https://www.squid-cache.org/"
  url "https://github.com/squid-cache/squid/releases/download/SQUID_7_4/squid-7.4.tar.bz2"
  sha256 "821f875575b042537a72ab4f0260496f447ccaf2c55dfd40a995f3ad238f616d"
  license "GPL-2.0-or-later"

  # The Git repository contains tags for a higher major version that isn't the
  # current release series yet, so we check the latest GitHub release instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "a650f7e6982042426fcc1a6519bc6835a6bb502d4e18da34bc6d1b1848dfa30f"
    sha256 arm64_sequoia: "5c1fe4302b298f4e8b69f65241983ca4ca6791b2c62b65f83b64ce29cb5ac3a5"
    sha256 arm64_sonoma:  "b4f8282a236951b1ad365e991b33e17deb992d5e9d32ff052a517c8d6059c5aa"
    sha256 sonoma:        "48c1e8705626c1e3807eeb5c39fc828ae1b980f09a16d0e64fac0794e558d947"
    sha256 arm64_linux:   "929b8b48dc4c43466cecb30c2bc86fd67aced3b96a6e383153aeb959d84e6493"
    sha256 x86_64_linux:  "d26bd799d2333db7484554e6a8aa4a85bf5acb62742c5a11c853ad2392add57e"
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

    pid = spawn sbin/"squid"

    begin
      sleep 2
      system sbin/"squid", "-k", "check"
    ensure
      system sbin/"squid", "-k", "interrupt"
      Process.wait(pid)
    end
  end
end

class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "https://www.squid-cache.org/"
  url "https://github.com/squid-cache/squid/releases/download/SQUID_6_13/squid-6.13.tar.xz"
  sha256 "232e0567946ccc0115653c3c18f01e83f2d9cc49c43d9dead8b319af0b35ad52"
  license "GPL-2.0-or-later"

  # The Git repository contains tags for a higher major version that isn't the
  # current release series yet, so we check the latest GitHub release instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "d2cd4e77ccc3da42ec7ded1f1f1a4a2e754734e17bf369b0dd99d542642ac4bd"
    sha256 arm64_sonoma:  "be53c543fec807a6841cc164cb9edb1433d26b8b4730bb0accacfdcebed45c63"
    sha256 arm64_ventura: "e7ef982e31124eb3b920cdc13351547b3bce8d574c8dddf18de73474dab7ae09"
    sha256 sonoma:        "472c374fa36f3e97a90d192d1fa4fcecfdd9cd45d5069e8c93ebd080ba581094"
    sha256 ventura:       "81747c30da12ba7291b8353836cea7708983d2e0775672462764076e5f1d4cdf"
    sha256 arm64_linux:   "11c4cde52a0d19d8768095309eeb87d9525d6f25992f51551ea40b87e56c1f02"
    sha256 x86_64_linux:  "86929f4464c2dd41698c7c68936bab3b9a716635cd57e5ab125086fcb23abca4"
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

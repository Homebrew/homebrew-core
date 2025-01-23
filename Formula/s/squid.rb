class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "https://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v6/squid-6.12.tar.xz"
  sha256 "f3df3abb2603a513266f24a5d4699a9f0d76b9f554d1848b67f9c51cd3b3cb50"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.squid-cache.org/Versions/"
    regex(%r{<td>\s*v?(\d+(?:\.\d+)+)\s*</td>}im)
  end

  bottle do
    sha256 arm64_sequoia: "46834c46b9dfba33e335871ea5521c52f0970e22492a10a7652e4c6ce7ad60d9"
    sha256 arm64_sonoma:  "0e5e93eebd07b2919e38a59becf1738a94d36d2ab36e8244fd0f50fb557acab0"
    sha256 arm64_ventura: "066142a4881ba69f68ab5c80f8997392225b44a3ffe1f6c098a457476ca55eec"
    sha256 sonoma:        "e47b6716e23cfe55ebc170cc8a563883e2d12bd2a0f7c190dbeaff3dcc3456d0"
    sha256 ventura:       "66876aa03fd2e9937b29cdb881fb1ced3ffd269209e282a4f2586f61fe3577ae"
    sha256 x86_64_linux:  "6706fe36e154fa9191414c35176698c6c3204ddae2ee3bdb415bbf5636b3099f"
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

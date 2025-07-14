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
    sha256 arm64_sequoia: "e5d41da43546f29e8d716313d9da5cc75b8b2a583b04176c6152a8713d4635cd"
    sha256 arm64_sonoma:  "5fb6f6f02bb7f4b9df597b999dd854c864ed7e1de1972c92ea5a222904febb80"
    sha256 arm64_ventura: "597b0aa9dd16fa1785d004269695362c5099ce58cf7a77a9a1538e7aa543d880"
    sha256 sonoma:        "ea431f4e87332de47fa00a5b01a1c1d16cfe209801560d4c6d40e9d33c6257b7"
    sha256 ventura:       "7c034b109868873e123437ac3d036889f5aee7142852f950b3bd972333fab6d1"
    sha256 arm64_linux:   "c67bd9de94046f89e8bc9eea23f75ca56bc4d0d7ea81ba4cc8676e4da9b4e171"
    sha256 x86_64_linux:  "b3f81a1434e3532567287e32d2fcc561502724e94bcb5715ff419d9c8d0cae1a"
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

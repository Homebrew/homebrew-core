class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "https://www.squid-cache.org/"
  url "https://github.com/squid-cache/squid/releases/download/SQUID_7_8/squid-7.8.tar.bz2"
  sha256 "0fcebf10aec14449abff30eb4cf7230f27d080601516d891f90a7e705de9f68e"
  license "GPL-2.0-or-later"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    regex(/^SQUID[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.[](regex, 1)&.tr("_", ".")
    end
  end

  bottle do
    sha256 arm64_golden_gate: "a3aaf0ea08eab1c8945bc96bc97f6e890870aeb8365c97f68ab0d42b803f22ab"
    sha256 arm64_tahoe:       "adc996cd5bd1b34ba2414e82bb2d01e57b41888d15ab3d27242413b4213e5ecd"
    sha256 arm64_sequoia:     "5f616f7e3606d0d87e4c66c63ee997f1affa51f0930c28f991dfc978f9e3a89c"
    sha256 arm64_linux:       "a320155b4c46bfd61425bdf77c9b82bc55df2ff586a38fe3ff1b5e569abd2c97"
    sha256 x86_64_linux:      "5940275e8ff7f9f58bb676e64b39f0e4b1128ba432576f95cfce473239fe3fe4"
  end

  head do
    url "https://github.com/squid-cache/squid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3" # TODO: OpenSSL 4 PR - https://github.com/squid-cache/squid/pull/2501

  uses_from_macos "libxcrypt"

  allow_network_access! :test

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

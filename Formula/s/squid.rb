class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "https://www.squid-cache.org/"
  url "https://github.com/squid-cache/squid/releases/download/SQUID_7_7/squid-7.7.tar.bz2"
  sha256 "1a748b91722259e986f17d85e0da9d9403054a50bc20f78394ff90e46ef55601"
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
    sha256 arm64_tahoe:   "7b250e8d878110a4c22f93c0a0c44089210d8aa3c3058ec69edaa926a42e983a"
    sha256 arm64_sequoia: "2f2da58c13f8c6721db90e9c1754ba3aaddc7e6d647a2111dc5b2c6be9d3b362"
    sha256 arm64_sonoma:  "c951f99d6210f9c700d3bbb8d824f3cf8366b0c4912e2706c2ea0bd634fb8216"
    sha256 sonoma:        "7e294547d94327e9a6edb905833ade8500ec945abe378bde26ee8faf6d5f161a"
    sha256 arm64_linux:   "0032de5c0ff11197c0c4ed1759f37146706e79bde51a9fc835127f55e2f286e7"
    sha256 x86_64_linux:  "9a1093809778462137fa0c9f613ffa29a220976aeeb0e69170391b4b0720999a"
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

class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "https://www.squid-cache.org/"
  url "https://github.com/squid-cache/squid/releases/download/SQUID_7_6/squid-7.6.tar.bz2"
  sha256 "29e6d2fcffbbbff0052c5a6a24a09f93c9b934fa95c0629ef2251e64ff8ff8da"
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
    sha256 arm64_tahoe:   "5b7238a79d06b8fb9bd7c96b4fe4f94c0edce93aaef611cd14d94b4471c5b0b4"
    sha256 arm64_sequoia: "1eac848cfc178305a55ccb2c7165c6928ef4f488b5a70a4b956752d57cd301bc"
    sha256 arm64_sonoma:  "dd8fe32a715cd8be05006c53859cf9bc767c081c58bf4746ff13f31dc6595ca5"
    sha256 sonoma:        "7b7b33b1477ec716d3fd390ede79275da044b87b12f09645012038a02c51efd6"
    sha256 arm64_linux:   "5a600a8f4c3bc5396376d447322a20ca493aacd036a43c91a8d37984d59399e9"
    sha256 x86_64_linux:  "8ebe7c178214bc82ecb4187cace7eb787f72b3d2ddb0766b2d1f090e40b0373f"
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

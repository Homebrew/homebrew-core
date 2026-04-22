class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "https://www.squid-cache.org/"
  url "https://github.com/squid-cache/squid/releases/download/SQUID_7_5/squid-7.5.tar.bz2"
  sha256 "61befa0aef1c0f04bad78906730da2ca15038d1fafe130aa53ce3b00aae23c90"
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
    sha256 arm64_tahoe:   "b9017646c31b4a67e21d3f46bb084658c5a9f70c1b4b99a812a04cbbff320736"
    sha256 arm64_sequoia: "983292fc24c38c06581ffe2c8aae64ffd9bf3bdd4f193862d43fb5d313e28ebc"
    sha256 arm64_sonoma:  "acc02e229c6459c95d51f6d3d71e7d9be19637508b8bdad2d443f2ab18dee91f"
    sha256 sonoma:        "b9e6b77436c25ec3f29222564ac15bb0d01fca747c5eab4480b70c978bcac086"
    sha256 arm64_linux:   "f3f76e4ca0addad257b2f59cfd0772130d465c04b6cc0f316be9ed635980fe43"
    sha256 x86_64_linux:  "9c76db4254d32667f2369d5ea63835c311865012e3870fad730c33216762df92"
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

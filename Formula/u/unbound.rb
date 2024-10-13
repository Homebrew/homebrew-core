class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.21.1.tar.gz"
  sha256 "3036d23c23622b36d3c87e943117bdec1ac8f819636eb978d806416b0fa9ea46"
  license "BSD-3-Clause"
  head "https://github.com/NLnetLabs/unbound.git", branch: "master"

  # We check the GitHub repo tags instead of
  # https://nlnetlabs.nl/downloads/unbound/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url :head
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "e5c7131e16e100134ee033328fbe60f3205cdb00fce61b343bb90c7086b9dea7"
    sha256 arm64_sonoma:  "97ab342851aa2bdb250e4c031134fee4b5449fc911350339a41e05b6502108dd"
    sha256 arm64_ventura: "af780cc19f019696aa6bf82171ff00e6cb88ef2f07aebf07aca4e47bb43090b6"
    sha256 sonoma:        "5d22db486e36e70db8a0c0c5fc3da39fb3e88563e5f78ac1c5e30b1174eaf43c"
    sha256 ventura:       "85eeec14c3a19edc973d67ee3f5f385ef15c456c3a91d6080775aaed4e1a533c"
    sha256 x86_64_linux:  "3f47387a16e61640ae47872593ad74070dd0c0e320ab91b64d902193da5d922a"
  end

  depends_on "libevent"
  depends_on "libnghttp2"
  depends_on "openssl@3"

  uses_from_macos "expat"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-event-api
      --enable-tfo-client
      --enable-tfo-server
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-libnghttp2=#{Formula["libnghttp2"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
    ]

    args << "--with-libexpat=#{MacOS.sdk_path}/usr" if OS.mac? && MacOS.sdk_path_if_needed
    args << "--with-libexpat=#{Formula["expat"].opt_prefix}" if OS.linux?
    system "./configure", *args

    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make"
    system "make", "install"
  end

  def post_install
    conf = etc/"unbound/unbound.conf"
    return unless conf.exist?
    return unless conf.read.include?('username: "@@HOMEBREW-UNBOUND-USER@@"')

    inreplace conf, 'username: "@@HOMEBREW-UNBOUND-USER@@"',
                    "username: \"#{ENV["USER"]}\""
  end

  service do
    run [opt_sbin/"unbound", "-d", "-c", etc/"unbound/unbound.conf"]
    keep_alive true
    require_root true
  end

  test do
    system sbin/"unbound-control-setup", "-d", testpath
  end
end

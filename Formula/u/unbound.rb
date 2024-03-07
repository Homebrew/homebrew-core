class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.19.2.tar.gz"
  sha256 "cc560d345734226c1b39e71a769797e7fdde2265cbb77ebce542704bba489e55"
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
    sha256 arm64_sonoma:   "8e9fca6e94de8d8302b98f9231062bae7b7bcc82325cc862e68c56b61e11bbf9"
    sha256 arm64_ventura:  "89a43610dcc2567d1d99249f4c6c512f6234654025943df1963f43491ebafcb9"
    sha256 arm64_monterey: "b3661edc73c489f3910ad2020fbe0b3df3fb025871ba4ae57dab2bf918812e99"
    sha256 sonoma:         "2e8eb9f92cecbbe2010546c93bcae5e7a74a708d8efc05d3cd2aa20370dde876"
    sha256 ventura:        "7f5485b63236c79d2224941d1014ee4121c433a6688f9adc71f9baee00f675df"
    sha256 monterey:       "54217359bc24f1cc9d40c8a5b7502196ab2c3c8d3f5d09bdb870d8edc53e59f1"
    sha256 x86_64_linux:   "8b036b56d6dee63a4e4a7ea68a5c970a93d1582d88e23ef9b8d97d7f8ee5ddf2"
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

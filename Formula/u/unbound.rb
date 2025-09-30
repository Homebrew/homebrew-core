class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.24.0.tar.gz"
  sha256 "147b22983cc7008aa21007e251b3845bfcf899ffd2d3b269253ebf2e27465086"
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
    sha256 arm64_tahoe:   "1086d90a5c2838c610f6625df55cd889c531921a09ca5d614f96ba8612f92ec6"
    sha256 arm64_sequoia: "4b5bebe5b624febc36c93b8fb90c009a811457bb8d68fd62c7b7f348968fdbb4"
    sha256 arm64_sonoma:  "2ade362851bb1325048c912f7c284bd85b9e2d433801df9c713c2a5a551fde9f"
    sha256 sonoma:        "a1f46c5210e28aab0a6fd4f9205ebea4738db65c822438a364d91d3928d84eda"
    sha256 arm64_linux:   "4163f0eede58e195c29e13f83a5166660dc060efb6627f78297d5de4725b2acf"
    sha256 x86_64_linux:  "52eca2a64cb39a525a1c47d49106c647d2e95bbe39d0d5d4c715973a16e860c8"
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

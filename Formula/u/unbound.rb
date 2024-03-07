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
    sha256 arm64_sonoma:   "3aad83b9d5674013acece85e4bd6f5d0e8d46b02fe5c8bc246ebabffa72fc946"
    sha256 arm64_ventura:  "a8324a47eda7e236c5a5939ba20480d1fce82ecf97833a55b0bd2265148f30ba"
    sha256 arm64_monterey: "7c54e69846bdab52fdadec881cbfd8ec4ed6dddcdef67191119b715e06e4ff39"
    sha256 sonoma:         "6da3dd086ff0957e0fe9d582ac157af804c6c52a5e4a92d83b1f6c1d862f585a"
    sha256 ventura:        "c13eeae9bee9e6f98cd115c5f4037b5445be1917fff22ce3d0e1142134d84871"
    sha256 monterey:       "cc5e0f6d7a40e7f8aea464024c23d1a1a9724bf6ae6ebd3fea44e5fcf9fcf5be"
    sha256 x86_64_linux:   "a25a0c92362c29d5cba4b6eb1ed879030209201ef28406bc4a0a9cfc2df8a1e7"
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

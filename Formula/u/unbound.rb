class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.22.0.tar.gz"
  sha256 "c5dd1bdef5d5685b2cedb749158dd152c52d44f65529a34ac15cd88d4b1b3d43"
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
    sha256 arm64_sequoia: "b1b2f3ec332c26033f00996f6caa847652848647e1a29d68fb9059547ace2373"
    sha256 arm64_sonoma:  "277b3f59fc64e10d079fa02a4872c0f921ab71f4e140863c47c1e2327ca9c133"
    sha256 arm64_ventura: "17686e80c85d436a27f924041f61c45c0dac68ad36da04f950f2dea26a35e66e"
    sha256 sonoma:        "76f56efe19cb9cbc6e2fc1fc053656d4e603b8a45fc7b6da707c23e81e4b29f8"
    sha256 ventura:       "3c43de07ff89234c7d9a7fc9fbcf3c0df0932872db9fa764d1bd7370305cf796"
    sha256 arm64_linux:   "a57889083ec9e201461a5a1dde25debba3e96d3fbf2bc1b0d43c782bdd14f6b2"
    sha256 x86_64_linux:  "a9db089b57722fb40fd586077155936973dbcee07176a4cdf98a46ffefc9cf5d"
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

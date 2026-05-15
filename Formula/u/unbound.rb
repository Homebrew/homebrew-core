class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.25.0.tar.gz"
  sha256 "062a6eda723fe2f041bee4079b76981569f1d12e066bbd74800242fc1ebddec7"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/NLnetLabs/unbound.git", branch: "master"

  # We check the GitHub repo tags instead of
  # https://nlnetlabs.nl/downloads/unbound/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url :head
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0ea9166a4b7231f0cd73b0c6e6fec63114b6e2697fcf0841bc36ac3b8dd00411"
    sha256 arm64_sequoia: "3220d79628029b34d13352bcb00440debe10d24f0184c6180cf9be66a2e58c3c"
    sha256 arm64_sonoma:  "a19a6712b6f63ac4fde2f7a1c82e6fd796f24d825e93d97b118d75d06165edd3"
    sha256 sonoma:        "bb5bd5b4ce182c28df322993473db74c74928a7bec7cbe9d3d52f63039defde3"
    sha256 arm64_linux:   "80096cbcb206668a12aca1c53f79f873797a75748b394586d6fe0af63ca6ee59"
    sha256 x86_64_linux:  "1c318031b4e6cfde3ee65824946645f907f9393f310ea652733fffb1f198b953"
  end

  depends_on "libevent"
  depends_on "libnghttp2"
  depends_on "openssl@3"

  uses_from_macos "expat"

  def install
    expat_prefix = OS.mac? ? "#{MacOS.sdk_for_formula(self).path}/usr" : Formula["expat"].opt_prefix
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-event-api
      --enable-tfo-client
      --enable-tfo-server
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-libexpat=#{expat_prefix}
      --with-libnghttp2=#{Formula["libnghttp2"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
    ]

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

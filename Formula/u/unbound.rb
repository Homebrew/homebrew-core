class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.26.2.tar.gz"
  sha256 "d8ee7aa6bbb3ff1be7d9e57637d0d0ec2f18273a8efff1a0afe2c665858b96f7"
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
    sha256 arm64_golden_gate: "e45285e85ad19dcd50a8477b2fc32077c3e1fabec3c434dfff44c9d8b415fc1a"
    sha256 arm64_tahoe:       "1ab3daeafae3e6dffa51583b8878e125c0aac2f68cfeddbfd2985a13b8c6cc85"
    sha256 arm64_sequoia:     "37bed88914f3c5c272129ffc1f2dea45580955cc115ac9237d599121c57d6661"
    sha256 arm64_linux:       "d9df0b4a4bd31fb7bd3b84796d51064378d41a7c8a427744b2bbdd75ccf71a07"
    sha256 x86_64_linux:      "03bdb0c1c8806af2ab7837786e8c64bd56ddaae1f320a0a90b476367b9645ed6"
  end

  depends_on "libevent"
  depends_on "libnghttp2"
  depends_on "openssl@4"

  uses_from_macos "expat"

  deny_network_access!

  def install
    expat_prefix = OS.mac? ? "#{MacOS.sdk_for_formula(self).path}/usr" : formula_opt_prefix("expat")
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-event-api
      --enable-tfo-client
      --enable-tfo-server
      --with-libevent=#{formula_opt_prefix("libevent")}
      --with-libexpat=#{expat_prefix}
      --with-libnghttp2=#{formula_opt_prefix("libnghttp2")}
      --with-ssl=#{formula_opt_prefix("openssl@4")}
    ]

    system "./configure", *args

    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make"
    system "make", "install"
  end

  post_install_steps do
    if_path_exists "{{etc}}/unbound/unbound.conf" do
      inreplace "unbound/unbound.conf", 'username: "@@HOMEBREW-UNBOUND-USER@@"', 'username: "{{user}}"',
                base: :etc, audit_result: false
    end
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

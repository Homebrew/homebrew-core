class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.26.1.tar.gz"
  sha256 "35a6dc0e425a9282c3426d9a3043144011bf0534aed4b73ab62c52aee0af1503"
  license "BSD-3-Clause"
  revision 1
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
    sha256 arm64_golden_gate: "4a9fc55920383275a3ed5621582c26820a25a22d0ba3ea3ffa79e6ee50daa246"
    sha256 arm64_tahoe:       "1f915777d85461ab2aff1904f95f777dbe482dbede274bc93d9a4518b1cf9045"
    sha256 arm64_sequoia:     "dc8d4efc2e5695816450f87260f4b5f3ad26ba96dd03346416fd74a67f5f1b5e"
    sha256 arm64_linux:       "f8caa9f61576e3b456c4c87c2a88a60057e350b33530422f2651ebb3b636e07f"
    sha256 x86_64_linux:      "8fbb7713d0be57c9de16cccdd86583839d55ff2461985eaa3859e8f765d6aeea"
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

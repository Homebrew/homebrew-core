class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.26.0.tar.gz"
  sha256 "77458a7156e275c0b7b17fabcb357cb12445d95cfcb26fb9bb7d5ecba45e0b63"
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
    sha256 arm64_tahoe:   "029c014b5d546a9f1df752aa3eab596900405aba33b2425fba15d545ab2132b4"
    sha256 arm64_sequoia: "291fdeea9b8decc2ddba0b6fdda9704c68fcf7ed0e3bace8e47299a43490472f"
    sha256 arm64_sonoma:  "e425db2eb4bb95c81d1820ffbcb6fe1212193182c42f5425a46b1f6018f07447"
    sha256 sonoma:        "078f66d2720fef061b8c0094de7e2a340e9ec5518039907b68f30da39c226766"
    sha256 arm64_linux:   "b0a83ff8d726e32eadb98ebca5c707a7acda9b0b64f3d0112992e8babaf32790"
    sha256 x86_64_linux:  "366ce454604f5929565b050637d256e3f0891ecdb387d5127a29994d87f552ca"
  end

  depends_on "libevent"
  depends_on "libnghttp2"
  depends_on "openssl@3"

  uses_from_macos "expat"

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
      --with-ssl=#{formula_opt_prefix("openssl@3")}
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

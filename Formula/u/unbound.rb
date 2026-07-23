class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.25.2.tar.gz"
  sha256 "0d92275c703d5f5f8baba3dab22117dd8c29b495588a5c229768ed6581566600"
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
    sha256 arm64_tahoe:   "29950f9cab564394414636776c41bf2d0591f3d06c54f3bde4fcf36631bd1b2d"
    sha256 arm64_sequoia: "50c5cefff391bd5840ec2c9abc4dacdb4e8adb9f10b25f211d90be46943a8310"
    sha256 arm64_sonoma:  "e430767590773a8fe3bfc6492622f1b7e2641f2ea3decfb1eef54f3b0ab34611"
    sha256 sonoma:        "5b0aea1703d65a952afbc75e5b04e2743159b1099e66de44bf22b780907f1660"
    sha256 arm64_linux:   "fc4814a75ebda3e6f49c44b8f1874e056d6a4fc3f818ec783f33b383d9a3233e"
    sha256 x86_64_linux:  "2e305c61374ebb81c9978fd960f19d030ce13cf968da4a2f6e359a69ecfbf8e7"
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

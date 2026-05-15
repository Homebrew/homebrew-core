class Shellinabox < Formula
  desc "Export command-line tools to web based terminal emulator"
  homepage "https://github.com/shellinabox/shellinabox"
  url "https://github.com/shellinabox/shellinabox/archive/refs/tags/v2.21.tar.gz"
  sha256 "2a8f94beb286d0851bb146f7a7c480a8740f59b959cbd274e21a8fcbf0a7f307"
  license "GPL-2.0-only" => { with: "GPL-3.0-linking-source-exception" } # OpenSSL exception

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e835eb13f39a9faebb3ebfcbbd26861145d379763e12c2b4da564bbd51d9641"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a4e0703c4b49df806565798a59db8bf4fd002d98389f86d01da2fe0daf1ac3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30484bca2d739fd9b5dead9de77d8bdd65484613b31ecd9fe798a90094f19304"
    sha256 cellar: :any_skip_relocation, sonoma:        "853138ede72687b12ea246000e969030ee9d11d78c1322998afe23a7d25b900e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec1fc05a11419233743f5f28a4c9dc73c211dc87d38ee1dab883a31c238732d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e47c47a2d6c5823c34e7334aad14180490f59a0a46061eb075db027eb49a46b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Upstream (Debian) patch for OpenSSL 1.1 compatibility
  # Original patch cluster: https://github.com/shellinabox/shellinabox/pull/467
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/shellinabox/2.20.patch"
    sha256 "86c2567f8f4d6c3eb6c39577ad9025dbc0d797565d6e642786e284ac8b66bd39"
  end

  def install
    # Workaround for Xcode 14.3
    # https://github.com/shellinabox/shellinabox/issues/518
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    port = free_port
    pid = spawn bin/"shellinaboxd", "--port=#{port}", "--disable-ssl", "--localhost-only"
    sleep 1
    assert_match "ShellInABox - Make command line applications available as AJAX web applications",
                 shell_output("curl -s http://localhost:#{port}")
    Process.kill "TERM", pid
    Process.wait pid
  end
end

class Shellinabox < Formula
  desc "Export command-line tools to web based terminal emulator"
  homepage "https://github.com/shellinabox/shellinabox"
  url "https://github.com/shellinabox/shellinabox/archive/refs/tags/v2.21.tar.gz"
  sha256 "2a8f94beb286d0851bb146f7a7c480a8740f59b959cbd274e21a8fcbf0a7f307"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9af5148d556c49c10cd2d8202f4172237928ce9c225a459eba11d4e2a6ab5945"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc3dcfc6ccd491c7a24fca6e89f3ee3c5547a379bc257904e323413dbe21619f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e5286ea7ca63bbada9f3f775f2f2d8c1006fb1f51c9640925ccceba4e0e37c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99818243818b0086763a7ceef6b417e5dd13b381cb9fd48e956566a26f74b3e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4511e725a582f0c03023a72a8178aadb64e6d8b05c359db2959fe606ab6bc4c"
    sha256 cellar: :any_skip_relocation, ventura:       "40f88ccd430e1264efea4852697d509ce3c8fa13a2c4a0d16c6415da020a82fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15393ab741f33679642c18979f8b84e8f0d164cdd014cc1579a446dbd6d40125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95159f182fd5741459af55763c3f1b3cc2e15d2339ecf59a54b23c8d83a0877b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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

    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    port = free_port
    pid = fork do
      system bin/"shellinaboxd", "--port=#{port}", "--disable-ssl", "--localhost-only"
    end
    sleep 1
    assert_match "ShellInABox - Make command line applications available as AJAX web applications",
                 shell_output("curl -s http://localhost:#{port}")
    Process.kill "TERM", pid
  end
end

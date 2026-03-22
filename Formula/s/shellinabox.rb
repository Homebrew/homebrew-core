class Shellinabox < Formula
  desc "Export command-line tools to web based terminal emulator"
  homepage "https://github.com/shellinabox/shellinabox"
  url "https://github.com/shellinabox/shellinabox/archive/refs/tags/v2.21.tar.gz"
  sha256 "2a8f94beb286d0851bb146f7a7c480a8740f59b959cbd274e21a8fcbf0a7f307"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d44a97956451b5823ac5d47639cafe695be2866bcb2d9328c52fc4e6755f621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd455ebd551e6bddf603d2889a98f8fdd406f68caded2f703c34f78327767862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c57bd624d71de46310675d95c75925e1b55146c44dd7d62e5e041291820e3abb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dba06f482a5bc45a102db5beb1fddd0e19bcfa715a9be908d04fb006e86c5c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaca8addc19bbac943421d2f17fff428722a7cd47607c42932acf57088ebd9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c64cf382e610886021ffa6d53b10353798293afd68b9ac286930e429df6da58a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

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
    system "./configure", "--prefix=#{prefix}"
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

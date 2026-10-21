class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/releases/download/v1.9.0/sngrep-1.9.0.tar.gz"
  sha256 "db1d45a27c5682a83ac9caedbca9a0af530c6da744b645d3f9b336d7ad2fc6a9"
  license "GPL-3.0-or-later" => { with: "cryptsetup-OpenSSL-exception" }

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "749bae5d19fb227dc6d87e6857d6a63db0974039f110cd37f5dae205ad6b6936"
    sha256 cellar: :any, arm64_tahoe:       "abf78211293da03ce442907fbe7bafac6a059cb3f8a272ee719c7644b1934d6a"
    sha256 cellar: :any, arm64_sequoia:     "c55668aa4a290d63bb629200891282b0ddf120d5f3e0fc09bc7bcc534e7fb7cd"
    sha256 cellar: :any, arm64_linux:       "3e5c4a4ef4052af19f93b67d22f972b04f38bb4bb363fb6f3168a640d2a54542"
    sha256 cellar: :any, x86_64_linux:      "137a1eb7890391ecf2ea187ad352b8f31193ecf88a4f64832e26ff91d5b87920"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "ncurses"
  depends_on "openssl@4"

  uses_from_macos "libpcap"

  def install
    ENV.append_to_cflags "-I#{formula_opt_include("ncurses")}/ncursesw" if OS.linux?

    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-openssl",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"sngrep", "-NI", test_fixtures("test.pcap")
  end
end

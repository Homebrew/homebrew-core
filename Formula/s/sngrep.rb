class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "1cd05bddd531b353e3069c5243e7076b60a3ee907dbbc3c9c2834676ed8c4bac"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0bfc56c0e4f1b9ffdea333a9fe372928b81b6bc0b931e3629b1c822bb062272f"
    sha256 cellar: :any,                 arm64_sonoma:   "af78fe4604a4b205135a31f113a35907d121d08bd7352f5747f82afbfbf7b964"
    sha256 cellar: :any,                 arm64_ventura:  "024eb3f86b15664e9cdae3dec40226b91432a2abe44bd3e6c72fbcff0f9c6167"
    sha256 cellar: :any,                 arm64_monterey: "2ce85bce10e93345e1991e4d23d92f46df955cf90c20bf47a0abe4eea4d9c0f7"
    sha256                               sonoma:         "57d93a31a23337e083f75ff3df8c40731fbd68d857678599184027f9240947c0"
    sha256                               ventura:        "9fdeee12cf3751750380301d66b61d0862e568b3f789e9bc21bd676b0495168f"
    sha256                               monterey:       "230ba56b3c53cd525f4dbed3495ec75c63cba1306c5d4cc5356573e22a2cf464"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "638308e2f58d25eecb2023dfb5e4c44bf344b664f428cd6af59b5a117b5a2827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6c9d43d767e6ae8f902fc0e74c4dff3ca255e94178cc0aa108e1241b797ea67"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@3"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    ENV.append_to_cflags "-I#{Formula["ncurses"].opt_include}/ncursesw" if OS.linux?

    system "./bootstrap.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl"
    system "make", "install"
  end

  test do
    system bin/"sngrep", "-NI", test_fixtures("test.pcap")
  end
end

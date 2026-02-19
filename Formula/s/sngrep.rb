class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/releases/download/v1.8.3/sngrep-1.8.3.tar.gz"
  sha256 "794224f4cd08978a6115a767e9945f756fdf7cbc7c1a34eabca293e0293b21b8"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "061db6e59e8b46db369feba26f33ad4d50082baf87580affeff0bdfbcb42f566"
    sha256 cellar: :any,                 arm64_sequoia: "7cff7081ff7899992673f68269bfafa11e62a143b39c9de3ad9731136ae72123"
    sha256 cellar: :any,                 arm64_sonoma:  "d128fa1a31902c76abfb557e18552670b54087cec17a9a32d7599ba93ad251f8"
    sha256                               sonoma:        "dd3ceac2f13d770f905b245f456f553fc6d0aa3335cb1513f28efa21068fff91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5a86128da8d87abf69575b2dbd298c2e2a75e3ccbe88b14624df356e723bbe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ab8d1e61cb58f5ab80ee2e230da31057941225c29cf867d176ca70ef3123da2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libgcrypt"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV.append_to_cflags "-I#{Formula["ncurses"].opt_include}/ncursesw" if OS.linux?

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

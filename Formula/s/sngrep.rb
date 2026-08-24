class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/releases/download/v1.8.4/sngrep-1.8.4.tar.gz"
  sha256 "0f5cc5a356edc1327f1b916fedd9eb0fd1472eda360a04dfe59cabe15a346ee1"
  license "GPL-3.0-or-later" => { with: "cryptsetup-OpenSSL-exception" }

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eef3346ace8a7ca9bf4f1959c061a91d20b3183d3d66ade367f724ded409e186"
    sha256 cellar: :any, arm64_sequoia: "726fcf6aacc3b31d24d8e168ef29de455a023c6d807847bf6bc32e4368c085ac"
    sha256 cellar: :any, arm64_sonoma:  "7e6ace0f22e451939f4a93f9fc068dd2bbb0273dce75f9219d4e3d63bbe6fa53"
    sha256               sonoma:        "adeec61bcd7f52381b05b1fcba9247181daa50b748893786f1a1ab19a5022580"
    sha256 cellar: :any, arm64_linux:   "79ea7ac2c6b0c15e4504e907e56d882623c63e20d4900f2fec9b29aa9f6dde60"
    sha256 cellar: :any, x86_64_linux:  "cf5e9049e811c3d93aa6fa6d85b5036d75725d38b3692c277962eb36a3150137"
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

class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "678875d44c6fdacb533f2d9e1b8db33ee8252723bb95653368fd43fae58969fe"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "68307fa5179d441454cb15e1ad2daa3e10b83aeb86314ada37508fedca78d1ed"
    sha256 cellar: :any,                 arm64_ventura:  "fb1e759d1bc7b451eb3bf5b3494321ba3407975a0e024023e8827ae2bed115b6"
    sha256 cellar: :any,                 arm64_monterey: "ed3f485d7f233e87d681fbe3129652a83499310e0e181009b1e96f62e79aa28a"
    sha256                               sonoma:         "ba93efa661eed18d6fdeb23cf5e973ce6f2b4ebe124d47ff6b3264e2ee89aff5"
    sha256                               ventura:        "c6ddc9eb9c12fa931e806036c4c917c252a2804b3dbc8fd2604a19ff143348e0"
    sha256                               monterey:       "c06d57f2e6d7965ce2fb5e442acf9cc317f16f353bc5b68e3ab84c727b8dceb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d76277ba85ee919973a64e3bef6fe04380765a3cd3da1ccabeff74188a376378"
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

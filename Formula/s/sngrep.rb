class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/releases/download/v1.8.3/sngrep-1.8.3.tar.gz"
  sha256 "794224f4cd08978a6115a767e9945f756fdf7cbc7c1a34eabca293e0293b21b8"
  license "GPL-3.0-or-later" => { with: "cryptsetup-OpenSSL-exception" }
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f72b1586ed174b41ce35ef705d6ae4c339ed026cc5df4406ccd60460e767307d"
    sha256 cellar: :any,                 arm64_sequoia: "77c7c05b46cdd48fcb7333e73c520c0f62ca97c66c0c60500c26f2d4922d6f9e"
    sha256 cellar: :any,                 arm64_sonoma:  "b76869c116279f94af0bed24bd7cbe1743ba3d5a11003b264bf5a68de24ba896"
    sha256                               sonoma:        "88813c882e63445fdc564f63232669d8408a326578dcdfe61779720bc2a2f3f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a72a6e8dc6a76f0414f7091114110655930f2d2a59817d7193529efd40db4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d000c2019a4cf2b7c0032beb1cf0c5b69df2d89958482b98ea8605e4765dace0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "ncurses"
  depends_on "openssl@4"

  uses_from_macos "libpcap"

  # Backport fix for build
  patch do
    url "https://github.com/irontec/sngrep/commit/b84f0663e47de6f238d9f81eed67612a9ab616ef.patch?full_index=1"
    sha256 "5212687f15f3e3e8f364634b18981e49ee022d612620079ed75c08d2a32a2f10"
  end

  def install
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

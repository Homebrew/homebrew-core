class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.20.tar.gz"
  sha256 "e8ee79b1f399b2d167e6a90de52ccc90e52408f7ade1b9b7135727efe181347f"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/akopytov/sysbench.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bd6313f906b867b19f8a7465b4f7a80169d2e4a7916d69f2da864437979e8966"
    sha256 cellar: :any,                 arm64_monterey: "817b352a292da3477b1756d821fad347e282eda93fa61a503251ec20cadb6599"
    sha256 cellar: :any,                 arm64_big_sur:  "3ed34ddca46da962077b1f690f802c852601f9af61aa265d2d31c5b44be24e14"
    sha256 cellar: :any,                 ventura:        "9f310c5ee955ff09898977b4851a94c80d832e248450a6e664817003475de65e"
    sha256 cellar: :any,                 monterey:       "5170b0cd36d6aa793244b06a2023eb4e6d8d62b5e56bc4b05d115ca28e7113f0"
    sha256 cellar: :any,                 big_sur:        "e873a2ca248c5c6dceb59860f928b2b6f3e1fb831a5b0d20fb2484f5f1a1afd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd8b79dcaf01792bc8f831adfabd4f98ea4409e0bbdc036b23ea3d8c008c05df"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libpq"
  depends_on "luajit"
  depends_on "mysql-client"
  depends_on "openssl@3"

  uses_from_macos "vim" # needed for xxd

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--with-mysql", "--with-pgsql", "--with-system-luajit"
    system "make", "install"
  end

  test do
    system "#{bin}/sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end

class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.20.tar.gz"
  sha256 "e8ee79b1f399b2d167e6a90de52ccc90e52408f7ade1b9b7135727efe181347f"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/akopytov/sysbench.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "40f5fc3a27f285b45dd864fc58d86dbcb5323e85539986973675bd2bd8a62029"
    sha256 cellar: :any,                 arm64_big_sur:  "cd5ffec8e0c4467c339ea6da2017c160acc695afda9e0e7572092eb6a2bf5a13"
    sha256 cellar: :any,                 monterey:       "b1cd2a8cd2e4a116976d7082b3e4c38b3df986a2033fe6e81745e6e9da25efe9"
    sha256 cellar: :any,                 big_sur:        "a79024100f669f978e69d22869dcfef53f15a7d2760e0268f94888a354068299"
    sha256 cellar: :any,                 catalina:       "df79e63911a44aa9f6a4b3eb0f9c74a1dd8ca5810b5f6d1a70ae79b1a58f29d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66d8aad04cd69ea97d38693e07231aba70312c269bf4687cd47f3d5dd3c98b8c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "luajit-openresty"
  depends_on "mysql-client"
  depends_on "openssl@1.1"

  uses_from_macos "vim" # needed for xxd

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--with-mysql", "--with-system-luajit"
    system "make", "install"
  end

  test do
    system "#{bin}/sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end

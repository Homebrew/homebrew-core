class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.20.tar.gz"
  sha256 "e8ee79b1f399b2d167e6a90de52ccc90e52408f7ade1b9b7135727efe181347f"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/akopytov/sysbench.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8f5fd6827291b2eb5f3a5b4c842a059182802d2ad97dcbd894046e5b2750914f"
    sha256 cellar: :any,                 big_sur:       "a9c638a46ddda6841018ad7354673315882a83e2aad7a480f46663db25e3c553"
    sha256 cellar: :any,                 catalina:      "f85e28b078ef05d9a155d0655275e6a9418494d94ab3dd524607a9c6ca84806b"
    sha256 cellar: :any,                 mojave:        "a29e37acd73943d5a1d72e6a5cb2f0812e2be3aeb061f919d271a8b31f2ac412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f9cf704a34e18ddf2b4e826500a6b98b6e0df6e9b2dcf85e93dfe9f5fa2988f"
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
    system "./configure", "--prefix=#{prefix}", "--with-mysql", "--with-system-luajit"
    system "make", "install"
  end

  test do
    system "#{bin}/sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end

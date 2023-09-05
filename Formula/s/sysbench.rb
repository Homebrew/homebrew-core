class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.20.tar.gz"
  sha256 "e8ee79b1f399b2d167e6a90de52ccc90e52408f7ade1b9b7135727efe181347f"
  license "GPL-2.0-or-later"
  revision 5
  head "https://github.com/akopytov/sysbench.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81962fb67a1580a33a35250ad0b1a04a03d37ad9a1d576b6a59e8b32325f1945"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d96776e2af71e38a6cf1e8ca92eef2279d84d6cae3f3eed3e0d6c6400d9b5ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8da6ba2affa28401106d38efaf5152545a59f91d5d07fdd766ce0e889b8ae22a"
    sha256 cellar: :any_skip_relocation, ventura:        "22b44b41d90e0784d60a4ddff9fc2227a85152df9bdc911e9925e69949fc294a"
    sha256 cellar: :any_skip_relocation, monterey:       "b407155ac959bac94e4f41b3e730495815b31bd129604ff69bed0435cacfc3c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d1192e27825c1176ddadae072936ff0364015e94d0f8bf36a06d63c0d262f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23f5b21581931bb1730facab837585e7f985d901f63daa3568575c975c886545"
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

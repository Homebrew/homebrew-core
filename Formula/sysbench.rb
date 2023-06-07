class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.20.tar.gz"
  sha256 "e8ee79b1f399b2d167e6a90de52ccc90e52408f7ade1b9b7135727efe181347f"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/akopytov/sysbench.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "302610a08d18657b6a2de17e7e9667a34d01300645a6d2ec16a3096e6359c37c"
    sha256 cellar: :any,                 arm64_monterey: "9bfbbac6e1d575338260108b3914071cbb536be9d27c90cd45c109217f230c98"
    sha256 cellar: :any,                 arm64_big_sur:  "996e9c33e004c9ce4395e4d378a501f4059b5c8c2153e6b7be6e9c35de68b992"
    sha256 cellar: :any,                 ventura:        "79b9d765d34f5e9b96905ad8701b45fb67ddb3b6a2fc1dc4cfea68486e76d754"
    sha256 cellar: :any,                 monterey:       "8573e4a94a2e817da5e52c28b40c1d2364d63b6775bbf9ed2ecb94952055e63e"
    sha256 cellar: :any,                 big_sur:        "721ed0a3b0d1d11c46527c5f73802f4477c069dbbb3fbc32d1bd80efe9574be7"
    sha256 cellar: :any,                 catalina:       "8a2b9c261bf7e1bafc840093bb949e8a55c94ffd5c060a05612f2bcec2f59754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc590aa5583607281a421e84e7d9e87539a873e340c5c9128d62920f1d571722"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libpq"
  depends_on "luajit"
  depends_on "mysql-client"
  depends_on "openssl@1.1"

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

class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/refs/tags/1.0.20.tar.gz"
  sha256 "e8ee79b1f399b2d167e6a90de52ccc90e52408f7ade1b9b7135727efe181347f"
  license "GPL-2.0-or-later"
  revision 6
  head "https://github.com/akopytov/sysbench.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "7d0ec825d215ef6254a94b211fac3f8e0dd8c9216161f94fb60b452736efbe9e"
    sha256 cellar: :any,                 arm64_sonoma:   "4e92ceff385e3387f6f15d7c77394c2be82ff22adafd9d00f080548bca4adfe7"
    sha256 cellar: :any,                 arm64_ventura:  "e3ee9a9bd7ff39e36970756e135e4bef97c78cd9530be51f1d2597f6a0f504bb"
    sha256 cellar: :any,                 arm64_monterey: "78ea88f48d0c55422c01c0b58c890f1dcbfa5841446c549a32186ea37fada432"
    sha256 cellar: :any,                 sonoma:         "c68d555ecd70155bd61acae1f1300572b5caf0106b730c3d4e2b2219fa20db13"
    sha256 cellar: :any,                 ventura:        "b32eb719d9495d239f5be45126d2c2477a9db451e19fc69933cf9460ef8f7a06"
    sha256 cellar: :any,                 monterey:       "e3add99698c5fe878ea1d89dc51ff49802b466e6d96875faabf7fbb77ccf2733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7875147b492684aa098117c40d2a6f2cc8997945ef94d27cb83a7f1a20e8ec2"
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

  on_macos do
    depends_on "zlib"
    depends_on "zstd"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--with-mysql", "--with-pgsql", "--with-system-luajit"
    system "make", "install"
  end

  test do
    system bin/"sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end

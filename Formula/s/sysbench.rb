class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/refs/tags/1.0.20.tar.gz"
  sha256 "e8ee79b1f399b2d167e6a90de52ccc90e52408f7ade1b9b7135727efe181347f"
  license "GPL-2.0-or-later"
  revision 6
  head "https://github.com/akopytov/sysbench.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "17c56c40b2c5ab0b9771892471db04149ca177750717be9ce5af114b6f893b62"
    sha256 cellar: :any,                 arm64_ventura:  "2cd8825fab0c36c7cadd7e8cd6251323f54f52733ea5d46927dfb47b946ca217"
    sha256 cellar: :any,                 arm64_monterey: "7873462239a08bd00fae9c58e5d4d32c353c1ea2358cacb70128540c2ad99f9e"
    sha256 cellar: :any,                 sonoma:         "a6fa13a7b2d27f397dbc1f0b5e81bba22f719fa7d239c0e4fce2481ad82b553a"
    sha256 cellar: :any,                 ventura:        "3e6f1e3c2daec2950ce462463dbab70c16aa8d89f71a174262167471d91259e6"
    sha256 cellar: :any,                 monterey:       "afbac084c8d329226293a3150c99e89b6d9cf8cebc45c1c2db8587fb0c5530a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26773367916c37a8a6eb26390cd72c953e199cf6d0bd61cf38531aa82b991453"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libpq"
  depends_on "luajit"
  depends_on "mysql-client@8.0" # Does not build with > 8.3 https://github.com/akopytov/sysbench/issues/522
  depends_on "openssl@3"

  uses_from_macos "vim" # needed for xxd

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--with-mysql", "--with-pgsql", "--with-system-luajit"
    system "make", "install"
  end

  test do
    system bin/"sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end

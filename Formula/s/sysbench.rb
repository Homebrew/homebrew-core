class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/refs/tags/1.0.20.tar.gz"
  sha256 "e8ee79b1f399b2d167e6a90de52ccc90e52408f7ade1b9b7135727efe181347f"
  license "GPL-2.0-or-later"
  revision 7
  head "https://github.com/akopytov/sysbench.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa75335616225f72f89bf9b8f75175f5eafaa320ec768c1a7fddcb0fc1fd8bff"
    sha256 cellar: :any,                 arm64_sequoia: "58353cd8988e133b4dfa59be80204cf6968ab6a733f9da7b3a53f561b74c4a20"
    sha256 cellar: :any,                 arm64_sonoma:  "88b6daa8909f7deca820c79d70651675e73bab3bf25e431ba72967ae78a932bb"
    sha256 cellar: :any,                 arm64_ventura: "ae000c8446a05ac27b143521afa5c0cb27d6f2fd85985a6b829f2d4c5983c8ef"
    sha256 cellar: :any,                 sonoma:        "6dc4d175800e0e93778a1d90ef77640a6678f6724f0aa3760aed0fb101c80ba3"
    sha256 cellar: :any,                 ventura:       "276837830f7c80059028dc02664bed943a465041127d6c9c09faaa3a00c1f837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a803836fb5e79e81b0b9dbd6d5104773e0b888f7e45986e03e586b2c6e4eb79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1d4498974cb5820ef3e1d532ae7ba041a7d201583c363d98674771caeacc7f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libpq"
  depends_on "luajit"
  depends_on "mariadb-connector-c"

  uses_from_macos "vim" # needed for xxd

  def install
    system "./autogen.sh"
    system "./configure", "--with-mysql", "--with-pgsql", "--with-system-luajit", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end

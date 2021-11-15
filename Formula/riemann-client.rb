class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.10.5.tar.gz"
  sha256 "568416d854d1c1e5eac743c9f56db6fa0d6a8144daa74a799d0556bb6b50e679"
  license "LGPL-3.0-or-later"
  head "https://github.com/algernon/riemann-c-client.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1646e7a5beffa940b68eea346c32ccfcb770b611d7fc2843da6f15616c2cc690"
    sha256 cellar: :any,                 arm64_big_sur:  "6ad0cf8ef43fc01df80a583cacb417077e6642df5580d7fa5cdcee6058dc457b"
    sha256 cellar: :any,                 monterey:       "64bce13b27ffd64cf9fc61b0452089c5287c7f25e897eb98af716fb8835d9698"
    sha256 cellar: :any,                 big_sur:        "2f1d22bea2043622bb483dcdc8232e4e848bc440705f78f5a093dcf5c1cb7293"
    sha256 cellar: :any,                 catalina:       "9b6a719337b59560368471b724d9e059b7b625e25ee9008cc69fe33fecb5f474"
    sha256 cellar: :any,                 mojave:         "0b2e63d5c1aa7a75fb6327e02e9dd0a4664e1d127ba46249da53361d4fe5f298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "766018c13d715c98a6f726191508bb498c8b3056d584a305ce3c2cae2661417d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "json-c"
  depends_on "protobuf-c"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/riemann-client", "send", "-h"
  end
end

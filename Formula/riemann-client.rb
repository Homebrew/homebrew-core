class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-2.0.1.tar.gz"
  sha256 "2ed963eeef5517f7be921790ef0cde13c7bcac172ac14ce5818d84a261cc3b31"
  license "LGPL-3.0-or-later"
  head "https://github.com/algernon/riemann-c-client.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b4d9f270930a03bd6d14c2e0673b37274b2dbe88601d9d5eed4e23b1651360d6"
    sha256 cellar: :any,                 arm64_big_sur:  "a903c8865839e11d8161aecead89d3446aaa02cec90ce473ff3581b07ef2901e"
    sha256 cellar: :any,                 monterey:       "0781e42d0d4650a9265d89c2dee9256d461816cf3b7e5f41de213e1ada9c221e"
    sha256 cellar: :any,                 big_sur:        "ef200e9b62011f846805a5a4b05e778b46fe4599d8b8a7600a6611a8a43c1832"
    sha256 cellar: :any,                 catalina:       "c328701c5ea1aa6101c54a3db32c39a5798fa27d88d898dd5ca2bad512f50175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f50dd475e3edc8145db2e9808ee16dd2d0cf795ee727d8a4d4d30d28af3960ca"
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

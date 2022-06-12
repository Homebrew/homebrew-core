class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-2.0.1.tar.gz"
  sha256 "2ed963eeef5517f7be921790ef0cde13c7bcac172ac14ce5818d84a261cc3b31"
  license "LGPL-3.0-or-later"
  head "https://github.com/algernon/riemann-c-client.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e258c3d69f945ca6e74c115212360f51dba2dd8cd7a7fe2b5ddc61abe655bf0"
    sha256 cellar: :any,                 arm64_big_sur:  "c4cee833659db746110a1f7efec8f7b0d0f51017685a36299d7da801708f2cd9"
    sha256 cellar: :any,                 monterey:       "f89040ef4e8103aebc2d0f0f7fc3f726075b3e0b0c17a1ba22c563636f1d3168"
    sha256 cellar: :any,                 big_sur:        "8477c2c7a301ea944f2e1bb1243870143940c479c9cc71e1532c5d6093184c51"
    sha256 cellar: :any,                 catalina:       "f8bab9f628c7c2eeba134634387ab554ba44beb5d4e3dc3368969d90bbfac9ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eacca5202c51e1bafaea6800bbbc86a575133ba4a9a15a9092a25142816903d"
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

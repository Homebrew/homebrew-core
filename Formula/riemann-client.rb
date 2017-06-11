class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.10.0.tar.gz"
  sha256 "74e6c8f79a230598278f44533b42b48a2f9531523a7e3d458e5618efc8f96b22"
  head "https://github.com/algernon/riemann-c-client.git"

  bottle do
    cellar :any
    sha256 "2313f0725f6d26800341804ebd819d3a569732cb1c909ea5ffc35c2d229317dd" => :sierra
    sha256 "c3eed9747670362a03b19f98bb14737374db2ec60f09db8465b781fa260503a3" => :el_capitan
    sha256 "c5d61a0d90db42fbc859068e6c1eac710e7b23ab5a4cf6b6f92b4680f1f49e5c" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  depends_on "json-c"
  depends_on "protobuf-c"

  # Fix build failure "error: only weak aliases are supported on darwin"
  # Reported 11 Jun 2017 https://github.com/algernon/riemann-c-client/issues/19
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1edeff1/riemann-client/alias-fix.diff"
    sha256 "4d4c33ab109688364ebbbcbf2487b1f80dd9b7aece0dfed8c4f1d804d0b56f3e"
  end

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

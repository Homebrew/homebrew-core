class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.10.0.tar.gz"
  sha256 "74e6c8f79a230598278f44533b42b48a2f9531523a7e3d458e5618efc8f96b22"
  head "https://github.com/algernon/riemann-c-client.git"

  bottle do
    cellar :any
    sha256 "9856af75fe69543e8e364c86a2be2ebd044e9b3de30c32e0fb7d6274199a0b5b" => :sierra
    sha256 "062a6545b63ecc33a9331509630443d77904132297c8beae3642aba6d2ba1b87" => :el_capitan
    sha256 "5e17f7589983a2f2e6e58516f7b6151032744d423b222502a23e572e6566b0f1" => :yosemite
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

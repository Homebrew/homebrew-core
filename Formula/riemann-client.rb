class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  head "https://github.com/algernon/riemann-c-client.git"

  stable do
    url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.9.0.tar.gz"
    sha256 "9584e8f1f442684a0f9607059874cfe1a1632c3fa5de2997b303ab8859048a3b"

    # Fixes "<inline asm>:1:1: error: unknown directive .symver ..."
    # Applies upstream commit "HAVE_VERSIONING: use #if not #ifdef"
    patch do
      url "https://github.com/algernon/riemann-c-client/commit/e6b49e68.patch"
      sha256 "7c0949e0719eea014ffb69f03f355b242f0d388907c18af4df90f8a4e3b8d60e"
    end
  end

  bottle do
    cellar :any
    sha256 "d672742751dca6f2743a496b3819596dab97bcd3f41b56a5c3ecd063026c6943" => :el_capitan
    sha256 "5eac36dbc72334c21da605445504f87bf4c81fae69870df44548749a71d804a8" => :yosemite
    sha256 "7e265d3c44bfde8103f85027fe851e2bdfc30d48074701520143f7b1348eed94" => :mavericks
    sha256 "957c3694c364c71358ac0fdcc3aa39bd7ba5b6afd0d8a8ad7c19cbde45e975be" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

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

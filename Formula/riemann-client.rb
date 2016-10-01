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
    sha256 "c65dd09016704ddf1a660fd0d7bf89078ef2dd79e89523e5b9fa73884c5854b0" => :sierra
    sha256 "d5ef5bcbdfb6db354cee483b5386d1e5d4822a49ba2d8c3d6bb01cdde395d638" => :el_capitan
    sha256 "05b20629c12c4f811681c9fb9ab7dba9d03e7e0bd165a929fd6051e72b2bea46" => :yosemite
    sha256 "b77b10a8d20c8abe43987de0459ea75b22b7afe3e5e9a71986e00378f7c3e3c8" => :mavericks
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

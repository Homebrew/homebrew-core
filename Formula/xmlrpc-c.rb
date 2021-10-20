class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.51.08/xmlrpc-1.51.08.tgz"
  sha256 "a48f6becfdc2897b8a90522ec506000f966a75e4a7c348c3f8b18fce828d49e6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "263c197c509a240444d4750945f8d7d079054844439dfa533bc0fd6d49632eac"
    sha256 cellar: :any,                 big_sur:       "98d8880157242c495ca5f3d2c87066b52fe858d5c14dc4078d1e8c1a63b7481c"
    sha256 cellar: :any,                 catalina:      "ea46c848e7b738b515733b89338f6e4d3a88f2ca35ba4c2188af5e165a671dac"
    sha256 cellar: :any,                 mojave:        "88ab4b50934d1d53dc0cc44e7985a2326757883a204c531a22c7d2867293d2b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9982d7f0d38a9b87fa13abbfaf64c3b2af31e2dc0361e836a9b41cdd190bf9c"
  end

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--enable-libxml2-backend",
                          "--prefix=#{prefix}"

    # xmlrpc-config.h cannot be found if only calling make install
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/xmlrpc-c-config", "--features"
  end
end

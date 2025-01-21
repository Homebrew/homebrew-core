class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.60.04/xmlrpc-c-1.60.04.tgz"
  sha256 "1e98cc6f524142c2b80731778fe8c74458936118bf95ae33cfa1e9205bfd48a5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "efb676599d96e83aeed7ba9922566f44f519c10f5f66273c7ebc315175a98c16"
    sha256 cellar: :any,                 arm64_sonoma:  "0847e1244a99ae5fd4247292564a328f88930e95604a2f6517ee4a801b48e582"
    sha256 cellar: :any,                 arm64_ventura: "a8d5697528386ec5cfa99be464e03b579d6ab002735b5fcc248ba52e1fdd0c69"
    sha256 cellar: :any,                 sonoma:        "a88ab300059fd024ebaa5b1e3c72b217abea7935af952ff39f307e4f1da2853a"
    sha256 cellar: :any,                 ventura:       "363da2d59bccb2be0263443addf0e8ad998efb73c77c08a18f6e38abb42ca283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ee21bfb6bff30d28aa9f0401ebbdc38825bc0fadaaaa147eb2977f4441df4b1"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--enable-libxml2-backend",
                          "--prefix=#{prefix}"

    # xmlrpc-config.h cannot be found if only calling make install
    system "make"
    system "make", "install"
  end

  test do
    system bin/"xmlrpc-c-config", "--features"
  end
end

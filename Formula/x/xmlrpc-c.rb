class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.64.04/xmlrpc-c-1.64.04.tgz"
  sha256 "509c3a3bffb77c81e2c364175ac70b95b799e5b695cc37d4bf833ec28fdfe0b6"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "320d56ff6025d45887470bee950ecfb5cdfda6f7739cefd2b6845e3de7ae3ae1"
    sha256 cellar: :any, arm64_tahoe:       "e6b25a7720dd3c8f45f6d0e39d0e571b6e07af1a63a1b88ef50af33c56f147b5"
    sha256 cellar: :any, arm64_sequoia:     "5cad13b02fa09ff044cc43d72f4f19a6893799d9b28b14df5eb724b82bfdfac4"
    sha256 cellar: :any, arm64_linux:       "a03eb071175741b250d64748c13d226b2affbc19809ba29c39a967107ddf28bb"
    sha256 cellar: :any, x86_64_linux:      "6a5262279f39aa1051f03f4ec43526aee049a5ff93f1062332fa6c13dfd1dad9"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--enable-libxml2-backend", *std_configure_args
    # xmlrpc-config.h cannot be found if only calling make install
    system "make"
    system "make", "install"
  end

  test do
    system bin/"xmlrpc-c-config", "--features"
  end
end

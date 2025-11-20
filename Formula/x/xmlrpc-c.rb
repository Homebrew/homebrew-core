class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.60.05/xmlrpc-c-1.60.05.tgz"
  sha256 "67d860062459ea2784c07b4d7913319d9539fa729f534378e8e41c8918f2adf6"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b6ed5b519e919c5e5d01c4398b5265650dc4be735152c2ef6284710a3cd24b9"
    sha256 cellar: :any,                 arm64_sequoia: "abe47cd7ae4198f396127bc04c73cb0fcf5c02ad44492f6ec35a8c855bf180e6"
    sha256 cellar: :any,                 arm64_sonoma:  "48a211f5416eb72fa3c95cfb908099e03ef7450f0be15d118ee322dc093d2658"
    sha256 cellar: :any,                 sonoma:        "a5bc2c69bac0b46244d5ba8fecda24094574a919c9bc9b838e1214d4d007715d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b95ce8d8a4831ceb6a72c8a8f9c541a1e938aaa864cfc64d078ac173daca811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b26ad9df48179d8dc1a9f7adc4ebae995c73bb5d0e8c2b29fcbe498a98c17f1"
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

class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.54.06/xmlrpc-c-1.54.06.tgz"
  sha256 "ae6d0fb58f38f1536511360dc0081d3876c1f209d9eaa54357e2bacd690a5640"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "55bd709cd5c8fccd713f628d870bb90b230de720603d4c280f5a90438d545c87"
    sha256 cellar: :any,                 arm64_ventura:  "784e39351c82ff015db8094e5be996bfc2aa421d5104d3c06a0f86eb02c4af04"
    sha256 cellar: :any,                 arm64_monterey: "ea86fe58a1b106920a370a8c3f66c09904000a57bb6f4b8644bdde24edac41ab"
    sha256 cellar: :any,                 arm64_big_sur:  "573d13e3dee5599d3e2abd555efc4b8c2a007d04f53d29baf706a2db6aa53d28"
    sha256 cellar: :any,                 sonoma:         "f4a290ded38ed7197b3ab2bf67e38c806c60419d4bdad345d7ab110b0d1d8cdb"
    sha256 cellar: :any,                 ventura:        "fbcf76517d21b0b006cc07ad3baac9f2a843908096b361558a021653d53d70f6"
    sha256 cellar: :any,                 monterey:       "b6a443d43d9b76f0255b7fd43a80a921e545973f1f7348c067a75746a440cfb0"
    sha256 cellar: :any,                 big_sur:        "cccdf3dc0450ce0efdb49f77651bf8d5263f621752e4fabc4d2db476bb5ea517"
    sha256 cellar: :any,                 catalina:       "38ed67ec4b4aee657e5c44a1cfb7527d5a5a32cf36d2e551eeb6d5733dfdfcce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cd0152929227f84c1f2ec41591f0d9484b82054d75aa99a1ac908df9ac634db"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    # Avoid errors with Xcode 15
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

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

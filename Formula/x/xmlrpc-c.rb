class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.60.05/xmlrpc-c-1.60.05.tgz"
  sha256 "67d860062459ea2784c07b4d7913319d9539fa729f534378e8e41c8918f2adf6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c618884cc42669b7cdd4147ffa1897b487ba9c1022c54c048cf0c40cc14ca1a4"
    sha256 cellar: :any,                 arm64_sonoma:  "c5322ce6f4b0d23b9c3b30dec56598faf7b9f6a880f679d9e1fb691e39caf5b8"
    sha256 cellar: :any,                 arm64_ventura: "1777fac56090d27fcd30b36e3d650da992bf6ba89e5898c87fa8ca38d34352e5"
    sha256 cellar: :any,                 sonoma:        "73add0f6405a8d62a7b76c0538c548a6ae8abc73669c50655f150fa7b35b7aaf"
    sha256 cellar: :any,                 ventura:       "e93fdf25ead371a86ef0f61d0af71ed63118f15387dd5e6c5902cfb9dec57df2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fc68a4419b803d9e9f6badf6966d955e15bbf81bad146d68f0b6be25fbce2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8abc661587c2c0aa4f4fe5cb086c812b448e4cc59ec388f492d7e871a1ce77dc"
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

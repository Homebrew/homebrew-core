class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.51.07/xmlrpc-c-1.51.07.tgz"
  sha256 "84d20ae33f927582f821d61c0b9194aefbf1d7924590a13fa9da5ae1698aded9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d2f823ee08ce4b5cf1db9b3c7df182b213c4e4757e89207de1147def940544be"
    sha256 cellar: :any,                 big_sur:       "a270cdb18af53d135dc5b46e772ebde0b0174aa4edcb334a3522ee79b7301f8b"
    sha256 cellar: :any,                 catalina:      "8f2f988116b29088d76766843fa5d2eafc2f33d919990baeb31f67fd9b8c0b53"
    sha256 cellar: :any,                 mojave:        "b058d27a7d2a0ba5a265186a5c4bcb26c9a9a0c9d4a60e639b30a72a2d4a7169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e5b7b127d74d52f7301aec65d8f868f8da9c3049113c9a746033995f0f9e261"
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

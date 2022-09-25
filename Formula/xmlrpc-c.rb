class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.54.06/xmlrpc-c-1.54.06.tgz"
  sha256 "ae6d0fb58f38f1536511360dc0081d3876c1f209d9eaa54357e2bacd690a5640"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2149f7bcfedc640b4f3fc5bed71b918dfcd07628b8d29857d6d9597c8789765a"
    sha256 cellar: :any,                 arm64_big_sur:  "d7580dbd85cf89067d5c921307e22006c58d957328e38e9b705d375671525582"
    sha256 cellar: :any,                 monterey:       "9ce660bd3b150fff43b4263149fc9c63501de5a5741dd3221537bc527e3ecc9f"
    sha256 cellar: :any,                 big_sur:        "2fa1b9c2d56df31a13c1f51c6654a4f9ac7bb6f2f34584c3fddf3266dd4e34fe"
    sha256 cellar: :any,                 catalina:       "79f0d65e19541e8e34cb76adcd3677f22ba4f41c7d0ec88750a61fc71b381010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dacb310e77da1d800e6904600f209e7e65fd1ac379dd25d18634044c9dc79dbf"
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

class Xmlcatmgr < Formula
  desc "Manipulate SGML and XML catalogs"
  homepage "https://xmlcatmgr.sourceforge.io"
  url "https://downloads.sourceforge.net/project/xmlcatmgr/xmlcatmgr/2.2/xmlcatmgr-2.2.tar.gz"
  sha256 "ea1142b6aef40fbd624fc3e2130cf10cf081b5fa88e5229c92b8f515779d6fdc"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ae788970290574145fa3ca20e389469f1a8582c8b604a50e3e506b7ffcb9faa4" => :catalina
    sha256 "eb8b0acfdaed325cce3e6b7befb53a675f9f7f6dc8aa5d058b4ebecea2d50e53" => :mojave
    sha256 "bbb201365fe9f89dc036d97e7bcb05d5b299e32f2ad427266f1d73934fd03cb4" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/xmlcatmgr", "-v"
  end
end

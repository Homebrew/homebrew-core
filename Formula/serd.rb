class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd/"
  url "https://download.drobilla.net/serd-0.28.0.tar.bz2"
  sha256 "1df21a8874d256a9f3d51a18b8c6e2539e8092b62cc2674b110307e93f898aec"

  bottle do
    cellar :any
    sha256 "55d28db3e4e0c7814d1c229aeec20516afc8db91d4ec913b2d476d1296f1b8c0" => :high_sierra
    sha256 "8ad52906db138cc480a3d75c1f9b6f245456a80c47de220c83acf7778bb55c48" => :sierra
    sha256 "dfd1ede14146b8222cf65e39c7dafe368a4abd474b2c5babddcd883a9f112743" => :el_capitan
    sha256 "654ac6e9843657faad3ec005d476f8812f9630e4ad56878c24bf93c17f66fa64" => :yosemite
  end

  depends_on "pkg-config" => :build

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end

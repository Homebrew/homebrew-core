class Tclap < Formula
  desc "Templatized C++ command-line parser library"
  homepage "https://tclap.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tclap/tclap-1.2.2.tar.gz"
  sha256 "f5013be7fcaafc69ba0ce2d1710f693f61e9c336b6292ae4f57554f59fde5837"

  bottle do
    cellar :any_skip_relocation
    sha256 "025227d952333920194194626d4e80eb02439a7de957a6722bd672a0cb2c7631" => :catalina
    sha256 "31d001dc926c1faf748a2dd0ad34fe9f3c3908400eac998802ce36ba78fab794" => :mojave
    sha256 "8e85cfa71594680dc52d5ff18d93cf585fc5990c28316f0b60f42584ff3a2697" => :high_sierra
    sha256 "8e85cfa71594680dc52d5ff18d93cf585fc5990c28316f0b60f42584ff3a2697" => :sierra
    sha256 "8e85cfa71594680dc52d5ff18d93cf585fc5990c28316f0b60f42584ff3a2697" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # Installer scripts have problems with parallel make
    ENV.deparallelize
    system "make", "install"
  end
end

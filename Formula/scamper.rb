class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20191102b.tar.gz"
  sha256 "bb9199476a94c922bac8d5337ac35abd559027152a7147e7a07bd5022fc59dba"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "ce4b06740377720808c70eedad0c3da7e99a5686ec34f68cb578b4644a78b14b" => :catalina
    sha256 "54d78388a155989fbb95dce2301f5ff72bb7bbc53ad3e067382c06600d63fc0b" => :mojave
    sha256 "0133b481958220fe1db704531da243d22a50b2ddb01a30513410037bc44cf613" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

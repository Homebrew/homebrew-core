class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/8.2.1/qpdf-8.2.1.tar.gz"
  sha256 "f445d3ebda833fe675b7551378f41fa1971cc6f7a7921bbbb94d3a71a404abc9"

  bottle do
    cellar :any
    sha256 "bc3e06830631ba2d447f0c5c6bd617c8ab8833db77d19d19470c5ff8578c430b" => :high_sierra
    sha256 "f2d688beff15973853e256b9771797c14abfff6a37963f8d49ea81e0c1c1cd4a" => :sierra
    sha256 "f91dcdb140a65c4d6406377ca39ea9c7bea871174ca0ef170a96411837b80024" => :el_capitan
  end

  depends_on "jpeg"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end

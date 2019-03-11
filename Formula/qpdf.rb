class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-8.4.0/qpdf-8.4.0.tar.gz"
  sha256 "39018f3bff700c68e41f6d44ea9f7842e2a5af200a80b2cdec7fa32a4abac4a0"

  bottle do
    cellar :any
    sha256 "181187634172ed037b2d5e46ff8d3332050cead64e06e8f7dbad5d4a8f3261c5" => :mojave
    sha256 "8da2f39ef2d2a477087abec933fa4c529c518dde0f374c0810619bea9ca4dd75" => :high_sierra
    sha256 "b0ff316e39641eb15a5eb18b1cff52bcdab343cb92b37de57adeb56c7e8efd73" => :sierra
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

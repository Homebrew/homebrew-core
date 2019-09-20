class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-9.0.1/qpdf-9.0.1.tar.gz"
  sha256 "2511f3daa131afe9766caec17bfd4f9cca7d849093ebe845530210a1055a0f52"

  bottle do
    cellar :any
    sha256 "7b1c8b45748711bad97608de2bd5bbd68a275c6291c86f4cec01a8e5b23f72fc" => :mojave
    sha256 "a03b47428722f8e5a7055d91eb2c3a9c2d165b31959a35d115b1d34a462a0741" => :high_sierra
    sha256 "c19ed3e45e2d3758d240c7b850a4847ab649e8596e01eafce9cabb44c78828f4" => :sierra
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

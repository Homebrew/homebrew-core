class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-9.0.2/qpdf-9.0.2.tar.gz"
  sha256 "d02451d906068947f45e5216032f0f29ae53313c70c4deedcf3c3e173584d22c"

  bottle do
    cellar :any
    sha256 "851b65a95caa9d8a24b1627aea706724000976e5b586b07073ea00631352341c" => :catalina
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

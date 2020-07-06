class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.0.1/qpdf-10.0.1.tar.gz"
  sha256 "5d2277c738188b7f4e3f01a6db7f2937ed6df54671f1fba834cd3d7ff865827b"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "5ccc930f3c428ba0838eb50778c5e0fbe7c984fb43b468ba959714d70a7813eb" => :catalina
    sha256 "38a233da22d6a6e00fea01f8aff2f609c27915fdf9a86687b44153cdf2c07f07" => :mojave
    sha256 "4615f85d75741f053733eb37f12c35e3264492f00e9086530f2a40c710a0d7ea" => :high_sierra
  end

  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end

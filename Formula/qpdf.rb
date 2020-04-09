class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.0.1/qpdf-10.0.1.tar.gz"
  sha256 "5d2277c738188b7f4e3f01a6db7f2937ed6df54671f1fba834cd3d7ff865827b"

  bottle do
    cellar :any
    sha256 "f47b9543d07cc98b4b9ac8735b23e674f6798d42612fd1df94302d8c4a78c53c" => :catalina
    sha256 "9ee611ea13f7a50f97cbe4a4807c97913ec8140d5a823a3ecd1f7c81591723b1" => :mojave
    sha256 "89df9f938a015adf401084632db7b29a8c2f4a55cc03cb30d195f7a73989f348" => :high_sierra
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

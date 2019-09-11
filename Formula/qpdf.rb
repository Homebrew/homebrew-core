class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-9.0.0/qpdf-9.0.0.tar.gz"
  sha256 "9d2a70c181ff7e5d92a0fc10c4973a2a8164d4fb71ce3584bc5f1740bd65379c"

  bottle do
    cellar :any
    sha256 "d04afb7f8fc491692074fe4319342615922d9e6f010366e767e0f019e6e3ac86" => :mojave
    sha256 "16d74b0f8a2e681ca0d32d7ddc75f9185ddd4ebd618f4d4766c43b7fb92a022a" => :high_sierra
    sha256 "264c78d925436b0df2d5ca5202241ca7655e6bcea4fb93f5aeb697ae2bbc824f" => :sierra
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

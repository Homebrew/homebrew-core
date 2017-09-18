class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/7.0.0/qpdf-7.0.0.tar.gz"
  sha256 "fed08de14caad0fe5efd148d9eca886d812588b2cbb35d13e61993ee8eb8c65f"

  bottle do
    cellar :any
    sha256 "20441ef157d913182f5a75a2fa40dca76b5b110b01ca64597a6bed5fe74b3797" => :sierra
    sha256 "da38c81a17b35f8ee25cd6a10fe2a55d6a81cf0c158152c4e0d957e64a6ca04d" => :el_capitan
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

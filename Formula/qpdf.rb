class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/8.1.0/qpdf-8.1.0.tar.gz"
  sha256 "7d1f4827a3801a4b7d63f66fa50bbe237e74911801f3d31ee9f22f73e36370d4"

  bottle do
    cellar :any
    sha256 "70f547353101ed34b84a04fb81d8c83ab9a45cb76938298ada86c0a800280f23" => :high_sierra
    sha256 "e76cf052bbd038c4988938366b85fe99b45a5eb4752955288754ba37e6878050" => :sierra
    sha256 "ed2e3099a3a11322e3f2160de2493ddede077391a6b8ca613bf9016141480728" => :el_capitan
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

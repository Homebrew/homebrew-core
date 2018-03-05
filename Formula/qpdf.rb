class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/8.0.1/qpdf-8.0.1.tar.gz"
  sha256 "b2768bf1df218e203a9bc1fb6e7a3a4314bf96a4bad27a42ff3cd981a4f7bb05"

  bottle do
    cellar :any
    sha256 "cb654c77907915638803106b1b8f95d89b12e918f1d91251cf85026b56e9a16b" => :high_sierra
    sha256 "6b5b3a97108e5f786889dabcd20c480e20d54a3c65e3db7837037ea456287e82" => :sierra
    sha256 "ca1320db50e3edb4a0e7a205acb5ebac7339918bde32010f2cec214b7d8f4c7a" => :el_capitan
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

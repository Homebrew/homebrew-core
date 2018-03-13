class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/8.0.2/qpdf-8.0.2.tar.gz"
  sha256 "b09e1730b515956903866619b466da359cc051ae8c9d8690d8e7a2aca493c8c1"

  bottle do
    cellar :any
    sha256 "491b6c47fb23c34bd80ff3ad69ec2de28e258b4789600d75aa6a80b03e6c28d8" => :high_sierra
    sha256 "abd90c3ec1121d80eb8a2965c9d6bde94e20362253807a74a3cee3b0d98a031e" => :sierra
    sha256 "e38740b89d6d5e9d6e5e164d3778eaaea1e4d3442fce717a1684f5f4505bf141" => :el_capitan
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

class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-8.4.0/qpdf-8.4.0.tar.gz"
  sha256 "39018f3bff700c68e41f6d44ea9f7842e2a5af200a80b2cdec7fa32a4abac4a0"

  bottle do
    cellar :any
    sha256 "33ad0e075e1851268bfb4bade32d3ca7d17822003e00cb5766b8345478c7d888" => :mojave
    sha256 "1c4074a17a297d78e60b6387959f2d7d4554ee50d41ea6e3f32aa305b1a69c5a" => :high_sierra
    sha256 "99b251d161c6897a20f39c286770f6a313caa89fc634933f91f23ed2a78884a1" => :sierra
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

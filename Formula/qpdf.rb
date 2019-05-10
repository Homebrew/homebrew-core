class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-8.4.1/qpdf-8.4.1.tar.gz"
  sha256 "07fd02b8b32f760ea86c1999f5a67086126437ea854b4064f02c55dbd0f04ebb"

  bottle do
    cellar :any
    sha256 "6167ce2ef997cb5f267970a5a50cdaa009ad581e0ceea8e1a1a2e4dd2337a7ab" => :mojave
    sha256 "38b9b16a52189b039da2893ff0b1b8969e79f96c09c1c704c9891bd2c059ea9e" => :high_sierra
    sha256 "255f1b7b6d476d6abe4291ca91b2b0f1ac81a7d2e0519df046e3be78623b0bcb" => :sierra
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

class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.3.2/qpdf-10.3.2.tar.gz"
  sha256 "062808c40ef8741ec8160ae00168638a712cfa1d4bf673e8e595ab5eba1da947"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9301aec752ffa0a1ad9f4d6bb10dfdce0025d7e2a2704a73a3972934b689759e"
    sha256 cellar: :any, big_sur:       "f554c67b93485a55d02140bc21176c85725cc18c61f74008d6883a6484248146"
    sha256 cellar: :any, catalina:      "1840d900bae9754ba862d0a287fbf22da64065dab24bcd0370b813b1324fe83a"
    sha256 cellar: :any, mojave:        "b8a925330f9f9633c3345b44add91491631a949b05fd0c0ab2e89d0e7d5c6144"
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

class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.5.0/qpdf-10.5.0.tar.gz"
  sha256 "88257d36a44fd5c50b2879488324dd9cafc11686ae49d8c4922a4872203ce006"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e9c0330ed2141fc0d002c713ebdc7eed450eb3983689d2d061dad9136b7fb0d7"
    sha256 cellar: :any,                 arm64_big_sur:  "74e4f00d627fff311d1732e9f279f1f3f6acd2374b0c741b8c83c97f1e1327b4"
    sha256 cellar: :any,                 monterey:       "f7086d5e00f0e00f76336ced17b7bcf9f3e16a178b0c67eb404656cb24ee7336"
    sha256 cellar: :any,                 big_sur:        "2baa98138a4f3375d126ddd336e98a1f95ffd21f43504a672d07f4d7a4ba36ff"
    sha256 cellar: :any,                 catalina:       "5902aa492e2acf73237342c57f86007fdaff0fd333fc4de0514cb7390e4ae4bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c18e99ac413881dd927c712b1a56261922a39d2cb4034ec99b0d129412e3e3e6"
  end

  depends_on "jpeg"
  depends_on "openssl@1.1"

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

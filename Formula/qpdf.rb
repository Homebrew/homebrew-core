class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.3.0/qpdf-10.3.0.tar.gz"
  sha256 "4649c66ddb3a4fc4b18927667fd3ae20a9edfbbdc1017ee1ed1e548d3abe00d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0f78ce71f607721920f1d556ce92e36ff35677cdf0191e672f33b8961a846027"
    sha256 cellar: :any, big_sur:       "22dfc12bbcb9eb5ae529e9765e555b4f0320712f315cce6d00d607d7399ae98e"
    sha256 cellar: :any, catalina:      "0782c454782100fbbcc34686d8d1d09506b5ab9ed6188a09ecea4fe9dfa93b00"
    sha256 cellar: :any, mojave:        "ee3f9c7170c36b9d3429904f07e873e3f9939b054ba7a8af69a6a9b54814cd2e"
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

class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.6.0/qpdf-10.6.0.tar.gz"
  sha256 "6f0fa51b4f9bd964f3045cf21d13f573128ec06a4d78dbdbeb5e332a53b0511e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dda3030998f65cf20552bdb3b9eef7f7c68b35979d8f6b36c3c3b98d9b5a07e5"
    sha256 cellar: :any,                 arm64_big_sur:  "92df84a90a4b8b5450aef8de1d61f53786cfb7ea6a3d33f8c73234921324720a"
    sha256 cellar: :any,                 monterey:       "fa34dc0ec4a59333dd1af3f1dd95e3d3244e09861682d5a2156708fe03fa4ef7"
    sha256 cellar: :any,                 big_sur:        "5eadc04ed3c8a58d418f02ce08a19f39e13f6e1a5609832b25352cac01a7f703"
    sha256 cellar: :any,                 catalina:       "f3a013040c97867ca4a6687670a01947a6f5df2c22159a34aeddc68d4cb61f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f5aa27bffc33492b40b47fb7b3feb558775a8a82635d4405148b0952f5755b"
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

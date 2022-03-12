class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.6.3/qpdf-10.6.3.tar.gz"
  sha256 "e8fc23b2a584ea68c963a897515d3eb3129186741dd19d13c86d31fa33493811"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "24944d4bf95fe2c8074f56a971fb02fc690debd23918e9167da0382610caca9f"
    sha256 cellar: :any,                 arm64_big_sur:  "8f49d18dd8988cc2c63edbc62ca3fdfe588d8da7c42ed166ed3eb47a891d93e4"
    sha256 cellar: :any,                 monterey:       "95850728bedd6bbc23746d6b3e9fb02178f622d66f4addc6b3e99bce78c7537c"
    sha256 cellar: :any,                 big_sur:        "382f9055e985efc460822feb662b6adccc31c0cd261e45e857408a01180c88a1"
    sha256 cellar: :any,                 catalina:       "68d14b83b59b4d0ca64b012aa7b57c90312c5eede3f0b5a7209512d4d8a1441f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b60263aafd42b76e159d8571dec80efa1ca5e411b592e92df1ea1d81935df399"
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

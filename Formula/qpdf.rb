class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/8.0.2/qpdf-8.0.2.tar.gz"
  sha256 "b09e1730b515956903866619b466da359cc051ae8c9d8690d8e7a2aca493c8c1"

  bottle do
    cellar :any
    sha256 "9fd9f92561462b908933e50460c613dd953497622958d1cd0417aa72ba9fc741" => :high_sierra
    sha256 "ed1a2d5507a5a86beb37a1f125c6a2d553ff1fbf3538baa2e4673ae24d8ce998" => :sierra
    sha256 "0c3a19ca49a699ac443255c25a8f684bb7c9c80133f1a477594a06f00bf681ff" => :el_capitan
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

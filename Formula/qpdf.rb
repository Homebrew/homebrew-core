class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/7.0.0/qpdf-7.0.0.tar.gz"
  sha256 "fed08de14caad0fe5efd148d9eca886d812588b2cbb35d13e61993ee8eb8c65f"

  bottle do
    cellar :any
    sha256 "e13fed06dbbb7aae8b6c4c7a32e1975603d18a61203ebb6b15094cd992cf9e16" => :sierra
    sha256 "de523886e15f79209dbe270043dc252ebd2856649ac94f98141f37c3436ed20e" => :el_capitan
    sha256 "d352cf417a9ee038157343f138ff3f341e5aa5d9e91757c3ce88950b4509aba3" => :yosemite
    sha256 "f7059fb9d944230b06ad8ddb34528e4090161ee0a3ddee7068a86046c61d4b04" => :mavericks
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

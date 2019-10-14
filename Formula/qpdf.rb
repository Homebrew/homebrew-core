class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-9.0.2/qpdf-9.0.2.tar.gz"
  sha256 "d02451d906068947f45e5216032f0f29ae53313c70c4deedcf3c3e173584d22c"

  bottle do
    cellar :any
    sha256 "bcf24ff1867321810bd7b563f08436420cee9ff5dba5f2da18671a735522f0fe" => :catalina
    sha256 "3789a7a12c6a2375165db35229154b0463edfd40e9d205db9342b086564f7782" => :mojave
    sha256 "0f79ce577ce7f4bde5edd9e4a62d0972d08b1271f0ec274d8dde91b7fb5c5656" => :high_sierra
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

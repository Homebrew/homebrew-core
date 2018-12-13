class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-8.2.1/qpdf-8.2.1.tar.gz"
  sha256 "f445d3ebda833fe675b7551378f41fa1971cc6f7a7921bbbb94d3a71a404abc9"

  bottle do
    cellar :any
    sha256 "d1dc8195734a59a37b403d4354d5a1df78d9e546ee48b54333f55bdce2fb8f05" => :mojave
    sha256 "375e32a6c852c44b16fbc143b3b15185607b2bbbcd1084343999839deff1dd0b" => :high_sierra
    sha256 "dcfc26a15e4cc9031901701cd708440d38cbf92bd3908c941331ade49a94ea5d" => :sierra
    sha256 "62d7195d5e9aa34dfd55ae65d554d55c4a8ef3f74a3abe1e85c2abfd8bd63c70" => :el_capitan
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

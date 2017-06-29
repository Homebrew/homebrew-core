class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.25.tar.gz"
  sha256 "ad486f8f45cba915ac74a38dd15f96a661a1803287373639c17e5a9b59bfd540"

  bottle do
    sha256 "c6fa4a694e7abbf431d52a76f24bba3035cfb3c0e6a2eadea7dd54d9612e9f82" => :sierra
    sha256 "1cb69fbe3d62af625c6289bd8759c41e349764cd33a60a4c867b8c02a9be8c38" => :el_capitan
    sha256 "40a4532a90e265dcbe85bfda55c6d797581cd7f02e91a660e1c14e03a5642ef2" => :yosemite
  end

  option "with-html-docs", "Installs html documentation"
  option "with-pdf-docs", "Installs pdf documentation"

  deprecated_option "html-docs" => "with-html-docs"
  deprecated_option "pdf-docs" => "with-pdf-docs"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    args = %w[install]
    args << "install-html" if build.with? "html-docs"
    args << "install-pdf" if build.with? "pdf-docs"
    system "make", *args
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end

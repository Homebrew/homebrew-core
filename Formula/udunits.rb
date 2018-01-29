class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.26.tar.gz"
  sha256 "368f4869c9c7d50d2920fa8c58654124e9ed0d8d2a8c714a9d7fdadc08c7356d"

  bottle do
    sha256 "29a5b54241ae8bfeddfa8105f372766dc2f06f4c1cb4018e55f16a9e1be8f49b" => :high_sierra
    sha256 "ebdc80d2869a347552cec43281545db11a2ef3dcd7e6a262047f28cb4fd2317b" => :sierra
    sha256 "db4058466d7cd3f29d53593dfeba45dbfec8c99a9378ac42f2f40af23ea63f6a" => :el_capitan
    sha256 "bcccbbb489918cedb52a0d33dfc760e63bec80ca4f6bfe92c50464285cd1f417" => :yosemite
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

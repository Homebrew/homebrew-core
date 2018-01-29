class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.26.tar.gz"
  sha256 "368f4869c9c7d50d2920fa8c58654124e9ed0d8d2a8c714a9d7fdadc08c7356d"

  bottle do
    sha256 "9bb90283343d3490d247eda07024cbdfa68b1dbc5255d2697c73ed2e73a29799" => :high_sierra
    sha256 "754d3116eb032cc012c164b0a5edea7432f6e6a4b2853a9b7153e560dfb9075a" => :sierra
    sha256 "5fbd4d1d36e471bc71720b61a1d4a76b363e115fc71b74208fc5284883087bda" => :el_capitan
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

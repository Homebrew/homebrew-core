class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.24.tar.gz"
  sha256 "20bac512f2656f056385429a0e44902fdf02fc7fe01c14d56f3c724336177f95"

  bottle do
    sha256 "4d065b10ac9a4dd56bac225d7646ec8015b6705096eb16b519ccc63b0e1bd063" => :sierra
    sha256 "52ec8673de095690828b561a5d42aacfffecb42fc6c2d46aa7f7867b31095275" => :el_capitan
    sha256 "f4ef4f1f5bc9bee628878a80c5876a2c03dc40414be4d4681eb9a5605e15e06d" => :yosemite
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

class Tidyp < Formula
  desc "Validate and modify HTML"
  homepage "https://github.com/petdance/tidyp"
  url "https://github.com/downloads/petdance/tidyp/tidyp-1.04.tar.gz"
  sha256 "20b0fad32c63575bd4685ed09b8c5ca222bbc7b15284210d4b576d0223f0b338"
  license "Zlib"

  bottle do
    rebuild 1
    sha256 cellar: :any, monterey:    "46db487f2849abbb7fa3123a5420bd06a782cc5fb23691e81f6d4a4ce3186e5b"
    sha256 cellar: :any, big_sur:     "7698a00e976bc8e04d0cefa0450713f73c658e694400fc107b161aa1184b2d72"
    sha256 cellar: :any, catalina:    "e9529c4cb157eb48b5d3a4cde35c4a8f1994496290a5a308b7feacd4b5bc58bf"
    sha256 cellar: :any, mojave:      "b48c3587cde0cbc77ff07e9cb6849dcd3a985d8360ab5e8e7a7d5f0691e5d68b"
    sha256 cellar: :any, high_sierra: "267b4c383278baa37d4bab8e10aba1ee73d2eba642332414fad77d262b602099"
  end

  deprecate! date: "2020-09-05", because: :repo_archived

  uses_from_macos "libxslt" => :build

  resource "manual" do
    url "https://raw.githubusercontent.com/petdance/tidyp/6a6c85bc9cb089e343337377f76127d01dd39a1c/htmldoc/tidyp1.xsl"
    sha256 "68ea4bb74e0ed203fb2459d46e789b2f94e58dc9a5a6bc6c7eb62b774ac43c98"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Use the newly brewed tidyp to generate the manual
    resource("manual").stage do
      system "#{bin}/tidyp -xml-help > tidyp1.xml"
      system "#{bin}/tidyp -xml-config > tidyp-config.xml"
      system "/usr/bin/xsltproc tidyp1.xsl tidyp1.xml > tidyp.1"
      man1.install gzip("tidyp.1")
    end
  end

  test do
    system "#{bin}/tidyp", "--version"
  end
end

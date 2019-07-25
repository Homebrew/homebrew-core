class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "https://github.com/Unidata/UDUNITS-2/archive/v2.2.27.6.tar.gz"
  sha256 "74fd7fb3764ce2821870fa93e66671b7069a0c971513bf1904c6b053a4a55ed1"

  bottle do
    sha256 "5d06e98f43d762c488ee32fdafcd11c6a1ba1e1527fb176cd2558a465701bfc1" => :mojave
    sha256 "9bb90283343d3490d247eda07024cbdfa68b1dbc5255d2697c73ed2e73a29799" => :high_sierra
    sha256 "754d3116eb032cc012c164b0a5edea7432f6e6a4b2853a9b7153e560dfb9075a" => :sierra
    sha256 "5fbd4d1d36e471bc71720b61a1d4a76b363e115fc71b74208fc5284883087bda" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end

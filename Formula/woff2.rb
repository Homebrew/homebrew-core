class Woff2 < Formula
  desc "Utilities to create and convert Web Open Font File (WOFF) files"
  homepage "https://github.com/google/woff2"
  url "https://github.com/google/woff2/archive/v1.0.2.tar.gz"
  sha256 "add272bb09e6384a4833ffca4896350fdb16e0ca22df68c0384773c67a175594"

  bottle do
    cellar :any
    sha256 "0d92977b90e1fe7699d1dc2bf1dd26407173e7c1da0ffc23d9459ca3fa3d24b1" => :mojave
    sha256 "dbbb582bc42ae47944c1004e3ec8017cc4a227e6167887dd0df6cde2571e2843" => :high_sierra
    sha256 "dc8769da8c1b1d81d9a186da0cabc8f06ab869ca82d5c7625ec9b3db15531e53" => :sierra
    sha256 "70df26c10ab652ba4e9f109936d93798922f17a88bc996343a2c840668963735" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "brotli"

  resource "roboto_1" do
    url "https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxP.ttf"
    sha256 "466989fd178ca6ed13641893b7003e5d6ec36e42c2a816dee71f87b775ea097f"
  end

  resource "roboto_2" do
    url "https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu72xKKTU1Kvnz.woff2"
    sha256 "90a0ad0b48861588a6e33a5905b17e1219ea87ab6f07ccc41e7c2cddf38967a8"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # make install does not install binaries
    bin.install "woff2_info", "woff2_decompress", "woff2_compress"
  end

  test do
    # Convert a TTF to WOFF2
    resource("roboto_1").stage testpath
    system "#{bin}/woff2_compress", "KFOmCnqEu92Fr1Mu4mxP.ttf"
    output = shell_output("#{bin}/woff2_info KFOmCnqEu92Fr1Mu4mxP.woff2")
    assert_match "WOFF2Header", output

    # Convert a WOFF2 to TTF
    resource("roboto_2").stage testpath
    system "#{bin}/woff2_decompress", "KFOmCnqEu92Fr1Mu72xKKTU1Kvnz.woff2"
    output = shell_output("file --brief KFOmCnqEu92Fr1Mu72xKKTU1Kvnz.ttf")
    assert_match "TrueType font data", output
  end
end

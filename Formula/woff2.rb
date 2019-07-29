class Woff2 < Formula
  desc "Utilities to create and convert Web Open Font File (WOFF) files"
  homepage "https://github.com/google/woff2"
  url "https://github.com/google/woff2/archive/v1.0.2.tar.gz"
  sha256 "add272bb09e6384a4833ffca4896350fdb16e0ca22df68c0384773c67a175594"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d3ccc0d5d910483c5fa385cf213bb352bfe886f1b824f8c182d050ae96e77fdd" => :mojave
    sha256 "f0a9cba72030b62b02336c277f2688ad96bf45c1720e58205cfa597be9860296" => :high_sierra
    sha256 "965310f79a417663d33d4917880b4dd2a9654ca85f5a9a243465e3e0e86a394d" => :sierra
    sha256 "59d4f6c77ae933445a0fde4b1445208a094169fa5dac784889dd6c8d4947c997" => :el_capitan
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
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
    ]

    system "cmake", ".", *args
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
    assert_match(/TrueType font data/i, output)
  end
end

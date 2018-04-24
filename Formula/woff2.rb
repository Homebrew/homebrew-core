class Woff2 < Formula
  desc "Utilities to create and convert Web Open Font File (WOFF) files"
  homepage "https://github.com/google/woff2"

  url "https://github.com/google/woff2/archive/v1.0.2.tar.gz"
  sha256 "add272bb09e6384a4833ffca4896350fdb16e0ca22df68c0384773c67a175594"

  bottle do
    sha256 "01a88969d60bbb128a4a73a6b9b6d4c75f4ff08b7c3df45139fc73b7fc76d694" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "brotli"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    bin.install "woff2_info", "woff2_decompress", "woff2_compress"
  end

  test do
    # Fetch a woff2 file from Google Fonts
    system "curl", "-o", "roboto.woff2", "https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu72xKKTU1Kvnz.woff2"

    system "#{bin}/woff2_info", "roboto.woff2"
    system "#{bin}/woff2_decompress", "roboto.woff2"
    system "#{bin}/woff2_compress", "roboto.ttf"
  end
end

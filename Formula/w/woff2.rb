class Woff2 < Formula
  desc "Utilities to create and convert Web Open Font File (WOFF) files"
  homepage "https://github.com/google/woff2"
  url "https://github.com/google/woff2/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "add272bb09e6384a4833ffca4896350fdb16e0ca22df68c0384773c67a175594"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "909e53d8bfc53e5f3f8a696caf90d3a2a950614f5590215b3ce6121ec1af3d40"
    sha256 cellar: :any,                 arm64_sequoia:  "f451e27be673ee74d5cdbbb50fa6d818ac48b0800f9daf0c27bb5995c27f8b9b"
    sha256 cellar: :any,                 arm64_sonoma:   "d410b566576b56a9659f6318591722b2c000d788be86e4c65cd28631ecd485a0"
    sha256 cellar: :any,                 arm64_ventura:  "fb62fd8c1f19bf0eabbc4e82ea9db15cb8fd74b158bc137a6e4da08a95c57759"
    sha256 cellar: :any,                 arm64_monterey: "1108c65b488acc65da207d66d8cb1c6964f4bcc23cfd29de4563d783a174d639"
    sha256 cellar: :any,                 arm64_big_sur:  "7ca5f49e0a75c2e9935606e2d065104bf7e29f48d767cdcd373e2f84a8a322b6"
    sha256 cellar: :any,                 sonoma:         "c0251f8aefd2a85acc108c31942c788b6e8b7c7dc76b39f91ece021f6e1393c2"
    sha256 cellar: :any,                 ventura:        "3583be57fecbc4f9c17c9bee38c9c484637bcb7b4868ff948811cdbe679a53c7"
    sha256 cellar: :any,                 monterey:       "04a13902818b9dfb1e5c82a8f5b50fae9681c058b6786a2bc86328543ed9c397"
    sha256 cellar: :any,                 big_sur:        "1f49de0effd6a13416745b3b9329aa42cefb0801eaa4740931b9c6669d18e1c9"
    sha256 cellar: :any,                 catalina:       "7df9b4ada2d8a72546c5395fc92a7c5071f68be2fa12d336a194cee44adad5a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7da30c0a9c4dfa9f52943749d7ec8bb8f25af1734a162015c009c422463fbb37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc6bb16039075d8610786f74387551da3a4852d0d6227ebefe1c5ef9add29d43"
  end

  depends_on "cmake" => :build
  depends_on "brotli"

  def install
    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Manually install binaries not handled by `make install`
    bin.install "build/woff2_info", "build/woff2_decompress", "build/woff2_compress"
  end

  test do
    resource "homebrew-roboto_1" do
      url "https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxP.ttf"
      sha256 "466989fd178ca6ed13641893b7003e5d6ec36e42c2a816dee71f87b775ea097f"
    end

    resource "homebrew-roboto_2" do
      url "https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu72xKKTU1Kvnz.woff2"
      sha256 "90a0ad0b48861588a6e33a5905b17e1219ea87ab6f07ccc41e7c2cddf38967a8"
    end

    # Convert a TTF to WOFF2
    resource("homebrew-roboto_1").stage testpath
    system bin/"woff2_compress", "KFOmCnqEu92Fr1Mu4mxP.ttf"
    output = shell_output("#{bin}/woff2_info KFOmCnqEu92Fr1Mu4mxP.woff2")
    assert_match "WOFF2Header", output

    # Convert a WOFF2 to TTF
    resource("homebrew-roboto_2").stage testpath
    system bin/"woff2_decompress", "KFOmCnqEu92Fr1Mu72xKKTU1Kvnz.woff2"
    output = shell_output("file --brief KFOmCnqEu92Fr1Mu72xKKTU1Kvnz.ttf")
    assert_match(/TrueType font data/i, output)
  end
end

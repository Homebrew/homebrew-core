class Tlx < Formula
  desc "Collection of Sophisticated C++ Data Structures, Algorithms and Helpers"
  homepage "https://tlx.github.io"
  url "https://github.com/tlx/tlx/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "24dd1acf36dd43b8e0414420e3f9adc2e6bb0e75047e872a06167961aedad769"
  license "BSL-1.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "24a8426be33e4421b2f636ba05b6784352bd1a559e5b2dde90ecae8420e0f591"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5e35cf4b2cf66334a3c6782fef229a96684942f5aa07063874e0020fb319e15b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2be507f7ba45c99557ac676c7c47b0288b5e364a2c61b33e2abf173865e8f9b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5bf4de79e505634d807afd511f8c30b43e1f770a0d727549f8428fa504308f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d67f614d8877c5fc1796c9e7c4d913fe085890e2556908fb7d0ee767c7bbdd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14ad8d90c73c62b2e9b1332ed5ffbe59487cfbcf36d0157390fd9e59327ec6c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "66a4109ede842a3ea53e81b6938ec834860b439d43254ddad12ed173ec479e9e"
    sha256 cellar: :any_skip_relocation, ventura:        "1fa9c67739a557c7faba1bf0a20352d8ecef8e79f32ba8caf2ef293fdc098dcd"
    sha256 cellar: :any_skip_relocation, monterey:       "0065add2f25b25eeb527aeb48625e34563d0afb702a496c67223ee78f3570547"
    sha256 cellar: :any_skip_relocation, big_sur:        "00ee92b029c92c9ac1f8326e9b039970097b802fe6ab79c2b8cf33251e3e7f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8740b303922f5a8190cddac66aeb6262a7c0dfa633cd98add555d0e4e1cdc6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67f35bf407415cf0ab4f5afba211439f82b8da3495a6a52b0301c3a76f099b8"
  end

  depends_on "cmake" => :build

  def install
    # Workaround for CMake 4.0+
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <tlx/math/aggregate.hpp>
      int main()
      {
        tlx::Aggregate<int> agg;
        for (int i = 0; i < 30; ++i) {
          agg.add(i);
        }
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltlx", "-o", "test", "-std=c++17"
    system "./test"
  end
end

class Sheenbidi < Formula
  desc "Fast and stable implementation of the Unicode Bidirectional Algorithm"
  homepage "https://github.com/Tehreer/SheenBidi"
  url "https://github.com/Tehreer/SheenBidi/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "86c56014034739ba39a24c23eb00323b0bf6f737354f665786015fca842af786"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14e0ca7bf19feb6565c75c0e6889b9ab52dc7c55ee9d5b428ad67558e3d1ce2b"
    sha256 cellar: :any,                 arm64_sequoia: "8739bf9ac68dcd4ee535d1ec547c6c6e84f896c15b53da2ddf58ab97d283631a"
    sha256 cellar: :any,                 arm64_sonoma:  "65f62b244de3488e95d71b92ce37d271c2c470f460e63f48f51a8d639396562c"
    sha256 cellar: :any,                 sonoma:        "435a97ad757c441b2ce145f23e00286d9ff4e34f0c54abec73274433f7c61515"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3414fb9606596bafb2f0cd482e98d7889fb6110dcf9acb7e2f3f89930d72862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2da48567cc1918a6b3f792915171e9aa1c4fcc0ec7df70455cdf7f6c4d25f87e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    args = [
      "-DBUILD_SHARED_LIBS=ON",
      "-DSB_CONFIG_UNITY=ON",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SheenBidi/SheenBidi.h>

      int main() {
        const char *version = SBVersionGetString();
        return 0;
      }
    C

    system ENV.cc, "test.c",
                   "-I#{include}",
                   "-L#{lib}", "-lSheenBidi",
                   "-o", "test"
    system "./test"
  end
end

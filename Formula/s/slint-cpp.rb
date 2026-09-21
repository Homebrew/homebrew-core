class SlintCpp < Formula
  desc "C++ library and headers for the Slint UI toolkit"
  homepage "https://slint.dev/"
  url "https://github.com/slint-ui/slint/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "fe485305ed303215e76c04918ee9aefbffbe229f18f979098ec36c7fa1dab28b"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "702dc9502a4dc60b9366d898ce844ea826db8e8ce14c1dd9a8a453b60a237cc2"
    sha256 cellar: :any, arm64_tahoe:       "a735e6d22a5b5ff4c8114cdd987ffb5af217fed357acd576dfce90a4a1d74ec7"
    sha256 cellar: :any, arm64_sequoia:     "146a8e4f8508781704cb8b4ccc5df1a8e33a5e02f9181cafd3b427d473ef1ae0"
    sha256 cellar: :any, arm64_linux:       "41fea2d425282f3076c0d20497eb2e3e83c57cc4e6b97f5584b5be788fac4891"
    sha256 cellar: :any, x86_64_linux:      "d8220a47b994d55247a5786bb47dd3cfc04751d1151704bcae69b00779b96338"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    # Optimizations recommended by upstream:
    # https://github.com/slint-ui/slint/blob/master/.github/workflows/cpp_package.yaml
    ENV["CARGO_INCREMENTAL"] = "false"
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "fat"
    ENV["CARGO_PROFILE_RELEASE_CODEGEN_UNITS"] = "1"

    extra_cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DSLINT_FEATURE_COMPILER=OFF
      -DSLINT_FEATURE_RENDERER_SKIA=ON
      -DSLINT_FEATURE_RENDERER_SKIA_OPENGL=ON
    ]

    extra_cmake_args << "-DSLINT_FEATURE_RENDERER_SKIA_VULKAN=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *extra_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <slint.h>
      int main() {
          return 0;
      }
    CPP

    system ENV.cc, "test.cpp", "-std=c++20", "-I#{include}/slint", "-L#{lib}", "-lslint_cpp", "-o", "test"
    system "./test"
  end
end

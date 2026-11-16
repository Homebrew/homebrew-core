class SlintCpp < Formula
  desc "C++ library and headers for the Slint UI toolkit"
  homepage "https://slint.dev/"
  url "https://github.com/slint-ui/slint/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "9c15a9f6dfe94fbe96cb97dcb38207907403a67c9b23d8a93468ea1bb132246c"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "19f43ad18bb266478f16453cb01be439d4715c6c43f5b4612e5b24db4ded7639"
    sha256 cellar: :any, arm64_tahoe:       "7ff281d61f06400196381e90649bc962c27922f7448e1930fae7e2e4b3f52abb"
    sha256 cellar: :any, arm64_sequoia:     "aa6cecda6368f9fac8832c05f6150b34a26c6386a41e82e1bbb6b1d6287a83fd"
    sha256 cellar: :any, arm64_linux:       "e996ed9097de81132c665276da97eb457c64e88c3ca5c29caf3d9a085cf8d0ed"
    sha256 cellar: :any, x86_64_linux:      "cf1be273661534a2894852b0137a2d0bb9c4ddb71f650d86a8ff9ac96dc42421"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
    depends_on "freetype"
  end

  # `skia-bindings` crate downloads skia during `:build` phase
  allow_network_access! :build

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

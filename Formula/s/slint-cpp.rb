class SlintCpp < Formula
  desc "C++ library and headers for the Slint UI toolkit"
  homepage "https://slint.dev/"
  url "https://github.com/slint-ui/slint/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "1cce5cc1e32a140e35366fe819fcf17a7b278338f67073d7bc97d4fa7a2a4d4e"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c4e17a18456a32758490a60614df2df42c2cf4d4f95312fd1a88888478bf3d3d"
    sha256 cellar: :any, arm64_sequoia: "6f62ccbe7992f45d0e7ec5a74bbfdba4244d98c53a54dfcaf53f3f14c4fba910"
    sha256 cellar: :any, arm64_sonoma:  "750924c1568a726565091cb57da31f70c1012090a96882d1ac5aad2804595786"
    sha256 cellar: :any, sonoma:        "2965eba242ab94ce7e625f7b5dcda3e5662d83de26ebe07776f93c27e9074ae0"
    sha256 cellar: :any, arm64_linux:   "164c67fd94bb302ae52bdb260438b2830f2fa6bd608da7542229834e970d9e9f"
    sha256 cellar: :any, x86_64_linux:  "f1cbeedaa58cacff75cf0b128b26d3a8511c6ada574e2cf2bef9d5df2d96d0a8"
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

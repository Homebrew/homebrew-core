class SlintCpp < Formula
  desc "C++ library and headers for the Slint UI toolkit"
  homepage "https://slint.dev/"
  url "https://github.com/slint-ui/slint/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "9c921f375de12fcf8647ddf076cf13af579b5cff61db5800e378cbedea9bff19"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  bottle do
    manifest_sha256 "599e54f2db4f165e712edff723ec1e612d4f5efa158b537ad989c086e9948d15"
    sha256 cellar: :any, arm64_golden_gate: "4771d6433dcec7df724d75c55599a1d68d6b4d99547eb5ad96fb7480263eb82f"
    sha256 cellar: :any, arm64_tahoe:       "71ca56a265260ce1f7c45db3806567d56b2e8fef588b0726808a09e9a4366281"
    sha256 cellar: :any, arm64_sequoia:     "309b04c96547842792d4efcc067abf65d2c5c19427776148df5925169fb4bd10"
    sha256 cellar: :any, arm64_linux:       "61c4f0ff229eae8e867a883d07dbaac77bf8295bfa53f319a0c37a6fd1a9d50a"
    sha256 cellar: :any, x86_64_linux:      "47799cd08ebe9d44e374db82b6e09ad5dd27e9677a8a9e792b2ba53a321453ae"
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

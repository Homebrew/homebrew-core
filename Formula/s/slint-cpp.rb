class SlintCpp < Formula
  desc "C++ library and headers for the Slint UI toolkit"
  homepage "https://slint.dev/"
  url "https://github.com/slint-ui/slint/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "68222567f8c70ff677cd4a98cd94fb4765ac0f797eb8f8608a646911c908dc2a"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "883bfd40161b12b860e39ef4113303ba610acd0af912b04b41cd944148373be7"
    sha256 cellar: :any, arm64_sequoia: "29938b7c67fc384bdca7ac36f7e8193d5b72ece52521ee5dddbe110e51a666f6"
    sha256 cellar: :any, arm64_sonoma:  "78c5e6972536a39571316a547226f310af0e1d9571b91d93df8645174da64f31"
    sha256 cellar: :any, sonoma:        "fa7817e90096b9091d634513b51721722a7f79658c70a399d436c920a148a28a"
    sha256 cellar: :any, arm64_linux:   "50031c3e2a873007c6b8df3603cbbb054698c74ce22872aac8d46633e9f5cf41"
    sha256 cellar: :any, x86_64_linux:  "d068802ba35eb6a11ff632bbc12d167112638852064a8fb28b08671773a2d7f4"
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

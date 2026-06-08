class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.4.350.0.tar.gz"
  sha256 "fbf9bee521545557357679173d39787a954bd8187e4b2fcaa09044c70201b434"
  license all_of: [
    "Apache-2.0",
    "MIT",
    "CC-BY-4.0",
    "MIT-Khronos-old",
  ]
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Cross.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "733bdc53b23929fa9a591ac1f45f65327a9b21c13767e123250b1e0ffec231ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a8a344890252d1f29fd27977e65efd76e1c5e828511b6f3cf560e57d1f3571a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bf6ddb38bd9ad977880b4e07a9f5ec77ca2e86591bfc35d54a5c9cfc12cdf7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1345dce4ab28ccf68b363f1cad8794adec22242b357b96e7dc606a9a1a6d829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdf73abb08c2292609c4d5431d1bbff8730669c0e25f4cf0fb2bd0db91e9d9d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df01299e1959ee86ed445f4be93b215eaa5a9f32cec348e2a709bd182ab786f3"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :test
  depends_on "glslang" => :test

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # required for tests
    prefix.install "samples"
    (include/"spirv_cross").install Dir["include/spirv_cross/*"]
  end

  test do
    cp_r Dir[prefix/"samples/cpp/*"], testpath

    inreplace "Makefile", "-I../../include", "-I#{include}"
    inreplace "Makefile", "../../spirv-cross", bin/"spirv-cross"
    inreplace "Makefile", "glslangValidator", Formula["glslang"].bin/"glslangValidator"

    # fix technically invalid shader code (#version should be first)
    # allows test to pass with newer glslangValidator
    before = <<~GLSL
      // Copyright 2016-2021 The Khronos Group Inc.
      // SPDX-License-Identifier: Apache-2.0

      #version 310 es
    GLSL

    after = <<~GLSL
      #version 310 es
      // Copyright 2016-2021 The Khronos Group Inc.
      // SPDX-License-Identifier: Apache-2.0

    GLSL

    Dir["*.comp"].each do |shader_file|
      inreplace shader_file, before, after
    end

    system "make", "all"
  end
end

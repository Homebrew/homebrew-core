class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.4.357.0.tar.gz"
  sha256 "97c910326afdd44d794ce8561326fa675fd1958b27142f03295403044d639639"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a02d41b640b88adb966762ee8a489e4afed26c6140f58fcdbbe4068273cf991"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bb080ac5ac116ffb7d75d1379aef679fc0924e4ed850ffe022311109fe57d93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ee0067b1591eec663b3a5bad92b0d92d04f52f3ba0bff7b08527906a827d306"
    sha256 cellar: :any_skip_relocation, sonoma:        "695370bf212bffe798876c04f58629a6dd0c8d60a6dfa384fe20460616d0bbf5"
    sha256 cellar: :any,                 arm64_linux:   "6c12b72c0a1ecf56deca50163a72c9c8b296ac229ccedec2b951c08cb2069f32"
    sha256 cellar: :any,                 x86_64_linux:  "565faaf37aaa8e0b1d0a1fc174619eaccad187a3464dfefdd205a85f3fafa129"
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

class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.4.350.1.tar.gz"
  sha256 "21057934ede32fe90a63dc304fdce0f2a6cb4f0ca685a72ed36a73aac6f72ad5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d5af103deb76ad31a4f8faeddbbff44ad4f24c0d94dc2b222edd78e4f1d52ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80e46d4350c5df2760c66144744684e1955b94d4bb73044ff6d0e541ac346013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "739c4dde7462d7648b6749d989940346e1cea4d7402a1de87fd17da5885e326a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c523622e1c10dcecd20b35de1ac5346e1d8f64b73bb3133e722250991f78cf9f"
    sha256 cellar: :any,                 arm64_linux:   "733f8f9449e254325a9087a653c619bb4bcf5f02ab5b6b2bab7afccdeb9c130d"
    sha256 cellar: :any,                 x86_64_linux:  "b0c834ba5f9a9d3ba0d4c499077d3e1270350ace16efc0790a5f4fdddb5bef18"
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

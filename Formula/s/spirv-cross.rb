class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.4.341.0.tar.gz"
  sha256 "b2665ac9ddb65ff75a7ca2f6d410e73da443692742a1e3a5b7728ca6069a400c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1977a16037658806a6d931d7949d5f06596cb7d6ccccca7416bef5c8813617e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e01b56657536588654f598ad53b1a71c6ef71a066579d42a0937690f59cf31f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ca057eed8da37851b2a40b57b15e2ccc4063af9e7c5d2e1ae5cca48a95c1194"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1bf1109ba614d7d6f511e703868c80a5ce44443bf75ed4ce131be730e3885d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c7fd48dabbefd574382784f2b66f679d36293dd50af3def498b4008c83a0370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c103084c571b223da6aa75f97471553926afc2bc4d9cab205f8084791ac6f858"
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

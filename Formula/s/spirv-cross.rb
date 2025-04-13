class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.4.309.0.tar.gz"
  sha256 "cf4f12a767d63f63024e61750e372ffdc95567513b99ed9be6f21f474b328ddd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c11d777c4c3d19e6b689ca9ab68e0b0eaa0cb814fa82a28e121f532c179c6dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "952eb717a8b50dea59454dfebd1f12982ae126c27b2567acbf84f699800d9fe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66a6937a801b5910ad226c4d224077a3e0cda7bd6ca6629132a561bec1a7d4f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "cef5e5bf0b464211ecc5e2a0598c361cac63a7386edbc85d79967826527ff6d1"
    sha256 cellar: :any_skip_relocation, ventura:       "acd20f2e7366f2146e323d29faf3a8e2f73092297918ece5cf29fceefcfa0d36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78df390f80fefdaa62237b847df8ff52b4960cf6334ecc40b05b8bd4123884c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1486b0f2d8f1dfffbcdfac239d3ec33a51ce140b86b6c97bd48458ac19d2c069"
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
    before = <<~EOS
      // Copyright 2016-2021 The Khronos Group Inc.
      // SPDX-License-Identifier: Apache-2.0

      #version 310 es
    EOS

    after = <<~EOS
      #version 310 es
      // Copyright 2016-2021 The Khronos Group Inc.
      // SPDX-License-Identifier: Apache-2.0

    EOS

    Dir["*.comp"].each do |shader_file|
      inreplace shader_file, before, after
    end

    system "make", "all"
  end
end

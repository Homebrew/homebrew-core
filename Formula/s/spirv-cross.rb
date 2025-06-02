class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.4.313.0.tar.gz"
  sha256 "7d1de24918bea9897753f7561d4d154f68ec89c36bb70c13598222b8039d4212"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "add1df549154c9c2f278ea006343076345302e60d48f68f957485add62bcae77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03588b24c1f09fbfebcd499622d0c54265a423f29888d51d94cf822f7d759cc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14cfd824228b3ff9f17eb8bb339a598c47f1657fb70c4eb63ee2be34c41e4225"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eedcf62ee9cefc2b3883105d8f45b8d8359c38928b9f3faa2a6ad5ebf091acc"
    sha256 cellar: :any_skip_relocation, ventura:       "732db42607529e74b09252d53255c0f709675a32f62c3dcd465bc9018e182b4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dff26ca56b06820999339bd65162f3aa4db10f93b279e48b224cbb1e7697248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf778372b13669b84c656c92a2539dd3539032b44d7d065f9c9b793434467992"
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

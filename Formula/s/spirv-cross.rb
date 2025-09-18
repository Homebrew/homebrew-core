class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.4.321.0.tar.gz"
  sha256 "6037555620c27105bf1d4068a6eeb4b0d7953630d556a1ca9799dfe06fd2fb68"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1446aa3f643e2b64fb7b6b3fdd9255ba5ae4205365029eceb3eaf381ced27fc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87647074b864c23bef5268dfc31f96b397d4d38ba342d0fae09236d233e2bda3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84972878223becea78af29319dfae91fec8d9c14c1d642a0c09bfbab5e24f39a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19614301478d5826dcedf9e41535421b39bd9d7df9724a8a01db289a290f14a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2438dbe0ac0c0eabc7b4b8dba501271980e0bd440380a68425e1687c420d4fb"
    sha256 cellar: :any_skip_relocation, ventura:       "292697589c3bc794b7fd9ce6b0b617314d7929a8e234aace55d6b1434149fd0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dd990444b8086bba223e8cad968256634631e9337a33d16fd5b2a437a0ea79f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28b8f9e1208b4a3986f94cf241b89f5a8e71e4408cdd520629074f06d56ce3d7"
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

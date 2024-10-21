class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.3.296.0.tar.gz"
  sha256 "4f7f9a8a643e6694f155712016b9b572c13a9444e65b3f43b27bb464c0ab76e0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94d2fa1830967dcf20e19901f13518fbe51c0625f29fc9509813b5200ebdcee9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afbd2b3aca191e95c3205df6d234c06f67c9505faebd78090cf466ee857fc98a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f614f93680d87ee7c48124d01f4a9bc731b655199ed588d41a193d43caa621e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1848ddb46b8c90a582d6369ad7fae6d4c3f8decd78372b82fff1f8dcdf5160f5"
    sha256 cellar: :any_skip_relocation, ventura:       "3eedd1eb6700688cd58ab559a078251308a15a98cdcda8dc041c02c2829edf34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcb20807bc4ee7b77f5c240c758d2f2085873b0a52c3f6b535b24c6ca184c0d5"
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

    (Dir["*.comp"]).each do |shader_file|
      inreplace shader_file, before, after
    end

    system "make", "all"
  end
end

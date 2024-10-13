class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.3.290.0.tar.gz"
  sha256 "1333fd2a05ab8a0572106e3b7fb8161ea0b67ab7d0a1b8bdd14b47f89ac8a611"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7428ac6774e8369880858880d5a63217560a01ff157defef899305e8a10d39e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86598042c486e94cb3670cbce05cd01306b1497dba631c6669265277a06b4edf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaaaa405ae2209dc2aee082033f45d2f2f39673c788d77998b94c37b34188dee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9860bafb482eb79e5c2dcd9020aed4aeb8d1096ed1627c6c0c1b38c6263efc51"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd4a92cbb204fcef3cba8e33339bea38d7f4c0dad0bde515b9a102cb76cdfa59"
    sha256 cellar: :any_skip_relocation, ventura:        "85b49e2d80b4e5c93ce8293e10bcba42f5fa337f5541e1e7aa25a18efbdb64d5"
    sha256 cellar: :any_skip_relocation, monterey:       "6db92465d5cd121ef852f671f497cb37d9ac3b0359768bf6404924e2693db70f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57a4818c15b37d3ea984bfb3179e79c10c29fd5c915823b63f46fcf5b6850409"
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

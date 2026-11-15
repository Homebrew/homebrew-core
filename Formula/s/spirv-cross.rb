class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.4.363.0.tar.gz"
  sha256 "f708982e88b763ef5b0394ed468fc2c3628f68cdab89f2e7a946cd628c04e721"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a62dcfc77bfc53b7c3801a3360591ce39cca2f8f417fe4a5f60f6bca698a455e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fbe28d5e8ec2373465870ee42a0c3ee145390748559a0542ddda8e6dd15d0555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3bd332f91d03227a11522d36e33c58736ddae7fff83db42d838ad3181a447eda"
    sha256 cellar: :any,                 arm64_linux:       "33a355d78320baf50422bea5c516713bfc882c3180ae929d276fafcbde0e02e2"
    sha256 cellar: :any,                 x86_64_linux:      "f54eca64170f7c3e79511286405e6ba26b8d4ff23d496c5472773ee8cd74bb5d"
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
    inreplace "Makefile", "glslangValidator", formula_opt_bin("glslang")/"glslangValidator"

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

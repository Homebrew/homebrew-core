class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz"
  sha256 "5b1149927e40a67396b440711543a3b1f9d004c844ca7293582a72c01cb69756"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05c4f8949044e5ffd935c30bf725e77abcabca2ce80bf820aab19f74ca7ce410"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5f82c0c5396ca4af47814944e3edbdc3e85ee444e711d93778156aa317aa708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1124f7140927ff1eea880f0894b3064361629f92e7d4bd548dcd1582d3188fc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c558f530f5ec6c20a352e134a13d180933273e5a87e44de05d791c1f8805ca82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bf8aba874568cb4336c50e145aaec4341e4f9e9373b6d55d17bc3c4acf63bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e33c0bf6232d7e14f6691bf5da762e59eee76119388f2fafe11357c5b77a057"
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

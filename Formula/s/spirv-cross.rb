class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.4.335.0.tar.gz"
  sha256 "c3e935cb19e2dda8e2e03fcfcbe451131595fec2cfbc73ab79a6f4c4cd43eb16"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eef4680c4336d0537b1199587f31607715a34bc2f325c7301e4a071ec60ff716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db422efce1ff115ea33ed85c7859b06f5519485ff2fc59c5ba408ebd999d1914"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff489b53b4183905f212ab430fc439c451a030896fa4194a93a4680c5897d0b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "29832daefd03c35e2107b023262747790b483b393fe19b19125ba55d73abe01e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b735499c50b3de38ae7b3bf05d4db1edc563a956257c816c8c2beb9806879a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "484acc91be3ab3a1f8d6e33a96d42903ab4647b372b553180f2ce0610c742336"
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

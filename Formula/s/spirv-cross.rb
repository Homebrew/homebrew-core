class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.3.283.0.tar.gz"
  sha256 "3376a58abe186a695a50ff12697d210ce27673cea5de1a5090cb2b092b261414"
  license all_of: [
    "Apache-2.0",
    "MIT",
    "CC-BY-4.0",
    :cannot_represent, # LicenseRef-KhronosFreeUse
  ]
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Cross.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "822c5fb08e99ff16844410ea490adc460476fe802e910b571081cf2b77092ea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc59b176849f94330d358bbe4a64d4114b84a731c757ac593e0db100a5a04024"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "959455ba86727a6f1e53d6fe1e8572febb30546ead99f182e4c0a697cc7e304f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf74559e1e9212cc01c8da988d4b45311014f6d7e3745a7ba282ee409b0898c5"
    sha256 cellar: :any_skip_relocation, ventura:        "37063cdce3dfc19c1921adf00ed5b8bed80791d857dd221da477a898ea696c8b"
    sha256 cellar: :any_skip_relocation, monterey:       "46299e221e669c42deca29f4f0dae8aa0b9a7d67b6012878ee64a3b64758de73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78c8f08c7f157c98ee17f6dfde6a009978f687f4a8a37aee29048b72d6ce326d"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :test
  depends_on "glslang" => :test

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
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

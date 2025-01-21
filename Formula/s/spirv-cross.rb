class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.4.304.0.tar.gz"
  sha256 "635b9b9ed2318df5ac65a0e1db1f92deb1e9c29e9dac30cd4b14eb3d72be5cf3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51864fcd01c93473a67a9961c017a24d512767faeb0ac07a104e4ed74719fd65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b5a2ed17a2898666ee7f94d66a1572e2aaf9aa93e8519d1defecf5daea91531"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b010469dbae8fdaf1d86cda20ea8e8ff311fed3e0dbb541bccc6c1b34a7fc4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "15e2625904616441388ae1f121f58a7fa959c0fe2a2d9ebcd9488f43b61cc057"
    sha256 cellar: :any_skip_relocation, ventura:       "e4d19e513b8a1f8a4a5f79a2cd4d005fae8d5a0cf3bce111602478c093215622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04533a135db4e5d4df029621d305a14058576727c218ae6c09f1c34a04c58603"
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

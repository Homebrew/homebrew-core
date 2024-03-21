class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.3.280.0.tar.gz"
  sha256 "eb11e1b3715b2211442b7e5933a1135885b664cc10530a1a022355fe9e1bb4ac"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc199704474bebd7b431d30db3697d8ad73366624fa936e8c87b6edbdeb7d403"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d96f55f74f5f494b20ac9f50bea082ff7ba1b1a2244f4adb0d57c983734a705d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ea53905825a9cf25b2d85ae805d0bc619c613d8b940f1845dc45cee066f712a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbfa477241b5dcd33a841dcb74fd898fd902282194c7ea326541cd0e051d1aa0"
    sha256 cellar: :any_skip_relocation, ventura:        "85e1ada77db3db4e7ea9e7b848d5fa1807e5cfad4a5008bf46b4f9f2c03d4830"
    sha256 cellar: :any_skip_relocation, monterey:       "327856ed35fb01f4c621b6c835636aa0fcc570c2dd9d829936f933bae78867f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0117e8221854bd940fd3c9a4f0c8fd13c9f12ed981c8fb0009a93667fa4bd803"
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

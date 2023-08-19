class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/sdk-1.3.250.1.tar.gz"
  sha256 "5b7402d7078eeffca0926875b1dcd0f5dd78791a30529de7c8456686f6fc52ce"
  license all_of: [
    "Apache-2.0",
    "MIT",
    "CC-BY-4.0",
    :cannot_represent, # LicenseRef-KhronosFreeUse
  ]
  version_scheme 1

  livecheck do
    url :stable
    regex(/^sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a0d0374846b8bbf1b8ea99f30861225c1d73345c00556173bf748bed7d8cde5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "999c8759b10c132d12208bac28f6cdc9cb69aa35a05d61eab220388044287626"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "489f5ab1d672983cdc6ee5518ba3a22d6ddfe1e9ab1c7f7e70719676c63e5e5f"
    sha256 cellar: :any_skip_relocation, ventura:        "f7b0421aeca71d23b3d48db19e920d998cd8bd0ac311c02df1ea30025a2b63c8"
    sha256 cellar: :any_skip_relocation, monterey:       "94080e31d9cf6fccdadeb9e0f472b68d3feaf7b6eb2f46a96f56073c86156c20"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0bf60714c9a937de136ae7257b04d8a80428c221eb21484a7566e9574b7c69f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c816877297d71fda95b12497cea592cd9874c848a6cfc5b8c97c0b8079abbda9"
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

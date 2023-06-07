class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/sdk-1.3.250.0.tar.gz"
  sha256 "dac4b3dabd3f166f0c2941cf72045331e2672591a06cdeaa72e550d403f3150c"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efab4f856ff256cfed3b78a31cc6bca1fdc7e1e5a43e4ecf3917f45303ecdd0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aecb2d362137229e8a17250d425a7b0a558ad6013b57837de87508213016b5e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92a072e86125773d91a254ee328819732fe1eca83417f3e2efb1bdec9906b521"
    sha256 cellar: :any_skip_relocation, ventura:        "df60834cbe46c2453a1fc45729133e33cb04a167d5661b4c9cbc02efd638855b"
    sha256 cellar: :any_skip_relocation, monterey:       "109d35612c303c6ac2ea4f711ff7239ef120081cfa279e3747a0e334454581f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "38b15cb2fb760782b03e20bb4a1ad06e7ad10dde85aca62acb96fe6c471b3c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98c3af7827e6143a5b4985a9589ceef269edd172a98946f294290b39bda61a3"
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

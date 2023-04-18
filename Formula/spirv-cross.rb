class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/sdk-1.3.243.0.tar.gz"
  sha256 "549fff809de2b3484bcc5d710ccd76ca29cbd764dd304c3687252e2f3d034e06"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ad959b1a5112c9142a09492d88dd2d7cfc810dea3685053f5fb3fce97e2b687"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fef027c5a5855599de4145c8a640f69bae7ba0e20a0e987b3b6cf3b4a29a5ced"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd28d93435ef2f3c9b8b340176243bf9c8a29ce5c9f2a24acc6f8b032802a07c"
    sha256 cellar: :any_skip_relocation, ventura:        "cb44b859d371478729d6ccf7e12020af1b5294660712a5dbb5f065aa432e5f04"
    sha256 cellar: :any_skip_relocation, monterey:       "97838df21c545cdc33916f6ff59beea3c2b25dba92c33d31540b31fb6b0debc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bf91e3290cc4cdd7dc5ce296d91ca05981c1299b90fbef4b6b5e3403bb178b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "befc9aee537f27295f7de8d2f03d4c0df3f7cbfb5530f562e481412afadce796"
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

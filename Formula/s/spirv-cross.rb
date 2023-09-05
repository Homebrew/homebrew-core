class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/sdk-1.3.261.1.tar.gz"
  sha256 "a5cf99ed62e93800232e50b782890321d4d7e053dcaa71bd8efc0c48a00bd1dd"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77f553581ef322a2b84a606df7cd8828aa9a30376119deabca220fded80fa898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec90f87ba39b1a8d97b6b02e4c9825664868ac2228ad79d89f7fbdf2765ba250"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b1d93633dc0aa445d6bb1e4481d9c04fb4be0f896bf92bfa0d09dfa1168562b"
    sha256 cellar: :any_skip_relocation, ventura:        "ed8a2b68e54d4ac7c5902a48e4854445c8c18e3cc9c009d178a7177609e9bd99"
    sha256 cellar: :any_skip_relocation, monterey:       "2bff4a16168252e0a48e659d6e2788a75d38854fa81f8f3979dc86353beb9904"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ee9d98a7d360e4eb41154204ddec314c0460897b8ceabc63b81f46bea855e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "330c96a3eb55a477cc3eec63d0e257893c561624466ebfa175236db5249c0ed9"
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

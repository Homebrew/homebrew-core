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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa560fce0ea4f29eed5e58236aa5c55a3d7aa7eaa349e6314a518f865b7eb38a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e1ea4fa8c471d0e0ae082d567eddb255c85ba2150b9977d2d6f75d3decf48c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d64dbb430d1a597d166eafdcab90b471089650d48d923a1a0352a5321e79da94"
    sha256 cellar: :any_skip_relocation, sonoma:         "d728b2bfa19e17e455d3b3bde1d1ca70f5bc0e6e9d4f66c0f5a8ddf8d9955aa3"
    sha256 cellar: :any_skip_relocation, ventura:        "9abedc17c84411be6f8c7384aec4695b8f75f67f1cf21fd9d0fb0399f3281dbc"
    sha256 cellar: :any_skip_relocation, monterey:       "8ba443f079f9aad3093062fe251fef86efdc8fb878f1d718e7269c8575d8b178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60cbb2afd7d197b7f38b6348004b5569a164c290b3bac565bcbb22eae594c913"
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

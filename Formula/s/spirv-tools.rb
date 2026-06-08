class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.350.0.tar.gz"
  sha256 "446b288fe76d3f31bbf9a405d62b97020ac0f135edb0ed5dbdf1136c488138f5"
  license "Apache-2.0"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "222c0a9b473dc3dd13e5af62507989e06b9be055a9054a9aba9a871f81422a76"
    sha256 cellar: :any,                 arm64_sequoia: "e082532c8ab7713b492639a5492a53d53cb031cc9df9759a886df34ddc9b959a"
    sha256 cellar: :any,                 arm64_sonoma:  "af7d9efce6e0201bb85d45ea09daced89e545658fa07bfbb7544bbe3703baf8e"
    sha256 cellar: :any,                 tahoe:         "347c9d17ee92b5876118f63d14964b9b183a063fb5effde0d0a8b4cc42983f15"
    sha256 cellar: :any,                 sequoia:       "015b80024dec204617b38ea6d3efb918f5a939afc79c7306ed521995ee7535e4"
    sha256 cellar: :any,                 sonoma:        "9453a45a63ed4af048da2b02f912c50ca93ea7b67877a155958f11dbaeb5709b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a61e701db32778377214820b77675df215fa7702c9b8f8ca25db183b87a8b349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1daf579c6fcf86454a23ae9478ffc61d7982cb591f94834aaf52719fa3101679"
  end

  depends_on "cmake" => :build
  depends_on "spirv-headers" => :build

  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-DSPIRV-Headers_SOURCE_DIR=#{Formula["spirv-headers"].opt_prefix}",
                    "-DSPIRV_SKIP_TESTS=ON",
                    "-DSPIRV_TOOLS_BUILD_STATIC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples/main.cpp", "test.cpp"

    args = if OS.mac?
      ["-lc++"]
    else
      ["-lstdc++", "-lm"]
    end

    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", *args
    system "./test"
  end
end

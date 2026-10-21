class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://www.vulkan.org/"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/vulkan-sdk-1.4.363.0.tar.gz"
  sha256 "4a078be12bef21cfebc09d878b77a63cff9d68f899254a0b00d0e37ef73e7f7e"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e29460a3bc874e18e407211f3e550cf60177c6f7614c04d3081beb94d8ad4ab2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e29460a3bc874e18e407211f3e550cf60177c6f7614c04d3081beb94d8ad4ab2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e29460a3bc874e18e407211f3e550cf60177c6f7614c04d3081beb94d8ad4ab2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd0b8a24787166873dc36d747982d3164299c181340ef2e14d8968f7ca05636e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fd0b8a24787166873dc36d747982d3164299c181340ef2e14d8968f7ca05636e"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end

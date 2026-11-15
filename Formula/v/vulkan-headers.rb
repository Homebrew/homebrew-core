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
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "64cb4ed61848cac6cbe070562d383f6d50a402524dee42f2a19ec0546736fe10"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"

    # Build an `:all` bottle
    inreplace include/"vulkan/vulkan.hpp", "/opt/homebrew", HOMEBREW_PREFIX
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

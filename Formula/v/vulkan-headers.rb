class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/vulkan-sdk-1.4.341.0.tar.gz"
  sha256 "d73bc5036b6556b741f6985ff600ca720308c5f2850e4a43ceb498bd3de069e7"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1c04ae00c5603d90d9dec39386d824bc75239abc3d3b58b1404bfe4ce891cdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1c04ae00c5603d90d9dec39386d824bc75239abc3d3b58b1404bfe4ce891cdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1c04ae00c5603d90d9dec39386d824bc75239abc3d3b58b1404bfe4ce891cdd"
    sha256 cellar: :any_skip_relocation, tahoe:         "bf673dbeb19b05465c269952cc2a46f6c17210209899c0252162f33bb3b4b633"
    sha256 cellar: :any_skip_relocation, sequoia:       "bf673dbeb19b05465c269952cc2a46f6c17210209899c0252162f33bb3b4b633"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf673dbeb19b05465c269952cc2a46f6c17210209899c0252162f33bb3b4b633"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf673dbeb19b05465c269952cc2a46f6c17210209899c0252162f33bb3b4b633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf673dbeb19b05465c269952cc2a46f6c17210209899c0252162f33bb3b4b633"
  end

  depends_on "cmake" => :build

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

class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/vulkan-sdk-1.4.350.0.tar.gz"
  sha256 "70270d10bf2c1e074a06ee37a50b75d332993d1b80a1d9526eeed2da6d82ed22"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc420a7f516094e9fa82981811ade1f547e2955db64d81019ffdeb6d48ee7208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc420a7f516094e9fa82981811ade1f547e2955db64d81019ffdeb6d48ee7208"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc420a7f516094e9fa82981811ade1f547e2955db64d81019ffdeb6d48ee7208"
    sha256 cellar: :any_skip_relocation, tahoe:         "b927b31768a66513e7e2fc74af2133f4c1f6adde837b1c7479fe95626f421b0e"
    sha256 cellar: :any_skip_relocation, sequoia:       "b927b31768a66513e7e2fc74af2133f4c1f6adde837b1c7479fe95626f421b0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b927b31768a66513e7e2fc74af2133f4c1f6adde837b1c7479fe95626f421b0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b927b31768a66513e7e2fc74af2133f4c1f6adde837b1c7479fe95626f421b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b927b31768a66513e7e2fc74af2133f4c1f6adde837b1c7479fe95626f421b0e"
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

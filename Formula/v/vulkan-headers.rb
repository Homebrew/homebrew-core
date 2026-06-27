class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://www.vulkan.org/"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/vulkan-sdk-1.4.350.1.tar.gz"
  sha256 "6d1bb65e49520344cc0a48af3dc02e993781efff14c7ebdcb8ae9fa23ddf7e83"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b94439ee3fade8cb511fe296e5d2b75c0ed2a5b9943feb4c94fcd5aac6c07a8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b94439ee3fade8cb511fe296e5d2b75c0ed2a5b9943feb4c94fcd5aac6c07a8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b94439ee3fade8cb511fe296e5d2b75c0ed2a5b9943feb4c94fcd5aac6c07a8b"
    sha256 cellar: :any_skip_relocation, tahoe:         "b482fc6a2e4831ae1b572370791cffb91f44ba08908885ee579d44fdfe1f43d0"
    sha256 cellar: :any_skip_relocation, sequoia:       "b482fc6a2e4831ae1b572370791cffb91f44ba08908885ee579d44fdfe1f43d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b482fc6a2e4831ae1b572370791cffb91f44ba08908885ee579d44fdfe1f43d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b482fc6a2e4831ae1b572370791cffb91f44ba08908885ee579d44fdfe1f43d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b482fc6a2e4831ae1b572370791cffb91f44ba08908885ee579d44fdfe1f43d0"
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

class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.170.tar.gz"
  sha256 "6fa84897197bd72cf4b1a686c903df67fc0fe108e4ed02e6adb3d72c468f1c1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "79e8ad5d156ab4699f44925f1f17d55400fb5dad56f6b1a2c03255b743af9363"
    sha256 cellar: :any_skip_relocation, big_sur:       "78af0c01a3c3fc809824e1d96b7da5f8bdd508ee7b569a7332b9b8e28c7b2db4"
    sha256 cellar: :any_skip_relocation, catalina:      "bb5a5c7098e04a7d12daebfc4d93b43e9da080976da683297130c3bcfac551f7"
    sha256 cellar: :any_skip_relocation, mojave:        "eacf7d282e32dca90b8d30ebbd5787891cdfbef04347c6d6fbb74ca33e5512ad"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end

class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.99.tar.gz"
  sha256 "37506deaf56b254193e4fa83195add2617e881efcac3d2ff5f0cf49353eb9aa8"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_predicate "#{include}/vulkan/vulkan.h", :exist?
  end
end

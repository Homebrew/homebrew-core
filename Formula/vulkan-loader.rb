class VulkanLoader < Formula
  desc "Vulkan Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/v1.1.107.tar.gz"
  sha256 "4a20b7887612999d0190c7c405cde84d1e5367984755b6605359addc38c28f1f"

  depends_on "cmake" => :build
  depends_on "python" => :build
  depends_on "vulkan-headers"

  def install
    headers_dir = Formula["vulkan-headers"].prefix
    system "cmake", ".", "-DVULKAN_HEADERS_INSTALL_DIR=#{headers_dir}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <vulkan/vulkan.h>
      int main(void) {
        VkInstanceCreateInfo instanceCreateInfo = {
          VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO, NULL,
          0, NULL,
          0, NULL,
          0, NULL,
        };
        VkInstance inst;
        vkCreateInstance(&instanceCreateInfo, NULL, &inst);
        // result may be VK_ERROR_INCOMPATIBLE_DRIVER
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.cpp", "-I#{include}", "-I#{libexec/"include"}", "-L#{lib}", "-lvulkan"
    system "./test"
  end
end

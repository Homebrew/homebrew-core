class VulkanPortability < Formula
  desc "Header files for the Vulkan Portability extension"
  homepage "https://github.com/KhronosGroup/Vulkan-Portability"
  url "https://github.com/KhronosGroup/Vulkan-Portability/archive/v0.2.tar.gz"
  sha256 "2508a2dd0e111cb7d4636a54d454e7172ab33c48cba0e6e86e6fdb7cf48becb5"

  depends_on "vulkan-headers" => :test

  def install
    include.install "include"
    (pkgshare/"sample").install Dir["src/*"]
    (pkgshare/"doc").install Dir["doc/specs/*"]
  end

  test do
    cp_r "#{pkgshare}/sample/", testpath.to_s
    cd "sample"
    inreplace "Makefile", "../include", include.to_s
    inreplace "Makefile", "/usr/include", Formula["vulkan-headers"].include.to_s
  end
end

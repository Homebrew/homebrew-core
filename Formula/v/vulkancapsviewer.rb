class Vulkancapsviewer < Formula
  desc "Client application to display hardware implementation details for Vulkan GPUs"
  homepage "https://github.com/SaschaWillems/VulkanCapsViewer"
  url "https://github.com/SaschaWillems/VulkanCapsViewer/archive/refs/tags/3.32.tar.gz"
  sha256 "788cb7a95aca4f61fca2423ea6f9c9ffaf814da61842d583f6e307b2816c7ac5"
  license "LGPL-3.0-or-later"

  head do
    url "https://github.com/SaschaWillems/VulkanCapsViewer.git", branch: "master"
  end

  depends_on "cmake" => :build
  depends_on "vulkan-headers" => :build
  depends_on "qt@5"
  depends_on "vulkan-loader"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DQt5_DIR=#{Formula["qt5"].opt_lib}/cmake/Qt5",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].opt_prefix}",
                    "-DVULKAN_LOADER_INSTALL_DIR=#{Formula["vulkan-loader"].opt_prefix}"
    system "cmake", "--build", "build"
    if OS.mac?
      bin.install "build/vulkanCapsViewer.app/Contents/MacOS/vulkanCapsViewer"
    else
      bin.install "build/vulkanCapsViewer"
    end
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "offscreen"

    system "#{bin}/vulkanCapsViewer", "--help"

    # FIXME: Tests disabled due to https://github.com/SaschaWillems/VulkanCapsViewer/issues/192
    # system "#{bin}/vulkanCapsViewer", "-s", "report.json"
    # report = File.read(testpath/"report.json")
    # report = JSON.parse(report)
    # assert report["environment"]["version"].respond_to?(:to_s)
  end
end

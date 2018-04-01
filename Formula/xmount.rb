class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://code.pinguin.lu/diffusion/XMOUNT/xmount.git",
      :tag => "v0.7.6",
      :revision => "a417af7382c3e18fb8bd1341cc3307b09eefd578"

  bottle do
    sha256 "88504e5b0c50741041083d475e74d3133556f72d5c07ac7ec5bc6425ea864422" => :high_sierra
    sha256 "4b036597229de4f7a2c45a9107d86abbc26ba37a2c574c77df4a8b56258f9fec" => :sierra
    sha256 "c86fd3b1b1f512190b38a3a937c23f496e365360c59c09943e0d0bbec2fe9504" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "openssl"
  depends_on :osxfuse

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl"].opt_lib/"pkgconfig"

    Dir.chdir "trunk" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"xmount", "--version"
  end
end

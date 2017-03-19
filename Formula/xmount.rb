class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://code.pinguin.lu/diffusion/XMOUNT/xmount.git",
      :tag => "v0.7.4",
      :revision => "ca84080b2c857de6951f154886bb7ed5fa100149"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on :osxfuse

  def install
    ENV.prepend "PKG_CONFIG_PATH", Formula["openssl"].opt_lib/"pkgconfig"

    Dir.chdir "trunk" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"xmount", "--version"
  end
end

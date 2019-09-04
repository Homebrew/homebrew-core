class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://code.pinguin.lu/diffusion/XMOUNT/xmount.git",
      :tag      => "v0.7.6",
      :revision => "d0f67c46632a69ff1b608e90ed2fba8344ab7f3d"
  revision 2

  bottle do
    sha256 "3cbc70ba1ced45797f95030b0509b0b2e3b2ad6d85cd1f4acdc362651d5e6ade" => :mojave
    sha256 "79b616ecf3e76ae690945cccd66b04b716aadaa61a82e34917be86c6ac4a367c" => :high_sierra
    sha256 "9fce7eb9aef96aaab3584783fedb7cece191cc9a218aba2ccc4ea7aefe38eb91" => :sierra
    sha256 "07295242dc494ee0f5612f2fb542011170725c0839f003fb876d3dc6eff6ac48" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "openssl@1.1"
  depends_on :osxfuse

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@1.1"].opt_lib/"pkgconfig"

    Dir.chdir "trunk" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"xmount", "--version"
  end
end

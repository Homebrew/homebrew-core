class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://code.pinguin.lu/diffusion/XMOUNT/xmount.git",
      :tag => "v0.7.5",
      :revision => "432ae6609af67f457e812378e6d2c7a1aacce777"

  bottle do
    sha256 "a7c90944e8790ce74164a68f484c07ce5231902a9ce0c81b7dea9ddbbbf47dc8" => :sierra
    sha256 "4aef49b3ed42bec95ff2c2922940a28b9c1be0b1bb04f28f37be1e01e1808120" => :el_capitan
    sha256 "2fd1e5caf50d64243c5151b016754acbe115d42150eb9a5ad26176e604fbb2e2" => :yosemite
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

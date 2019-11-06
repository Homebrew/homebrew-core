class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://code.pinguin.lu/diffusion/XMOUNT/xmount.git",
      :tag      => "v0.7.6",
      :revision => "d0f67c46632a69ff1b608e90ed2fba8344ab7f3d"
  revision 2

  bottle do
    sha256 "bebc8f0d6a5180519b332e5dd7e57a889cd449a9d9622cadbcb2798c8406adf8" => :mojave
    sha256 "0acfa64ed6e2129f820f75f42bddebf8019a340b8f2065fa00bce404fa538002" => :high_sierra
    sha256 "719156061104c0a14e111817b966bdc4d8f6f0cafc1cebd30125009132c3811b" => :sierra
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

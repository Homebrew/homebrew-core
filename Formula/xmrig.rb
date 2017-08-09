class Xmrig < Formula
  desc ""
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig.git", :tag => "v2.2.1", :revision => "92d787c817dfa92ca38e36f634195f31ff7d40c3"

  depends_on "cmake" => :build
  depends_on "libuv"

  def install
    Dir.mkdir("build")
    Dir.chdir("build")
    system "cmake", "..", "-DCMAKE_BUILD_TYPE=Release", "-DUV_LIBRARY=/usr/local/opt/libuv/lib/libuv.a", *std_cmake_args
    system "make"
    bin.install "xmrig"
  end

  test do
    system "#{bin}/xmrig", "-V"
  end
end

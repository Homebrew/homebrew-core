class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/archive/binary_0xd.tar.gz"
  sha256 "76146aaeb404e1d84607f8dfd1f31062216b4d5053dd14c72b3dc6df3aaaad9e"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_TESTS=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system "#{bin}/wast2wasm", testpath/"sample.wast"
  end
end

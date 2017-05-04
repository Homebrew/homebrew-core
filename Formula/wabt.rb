class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/archive/binary_0xd.tar.gz"
  sha256 "76146aaeb404e1d84607f8dfd1f31062216b4d5053dd14c72b3dc6df3aaaad9e"

  bottle do
    cellar :any_skip_relocation
    sha256 "58b9c542ba305f58925927e69d4d82398c692edfd88763d87d0c92b4051cf255" => :sierra
    sha256 "5b44ad223cf74abb50649839fb7151e53875e87ef92bb2b5ec9ab006ea97a2b2" => :el_capitan
    sha256 "907457be2158b3a004b61f22db0497c47bf06e0af3b61c6778ad0e9e20ae12b4" => :yosemite
  end

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

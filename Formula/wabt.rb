class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
    tag:      "1.0.20",
    revision: "830d32a41449278cacb0bf17530618d47c43340b"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/WebAssembly/wabt/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "08c32dd387bd3b1288c919a83f92f0f2c5a9e9e092078c2046e3c73a84e2d700" => :catalina
    sha256 "04e765099fc579a310d5b1f6d73fe0e806de1101b3509eee389b6ccf7c99a8fd" => :mojave
    sha256 "ddca29a3a9e019781add7050d40c7ecf61db5526dfff6282bfab520bccfffc74" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system "#{bin}/wat2wasm", testpath/"sample.wast"
  end
end

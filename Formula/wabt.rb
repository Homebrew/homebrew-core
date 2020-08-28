class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
    tag:      "1.0.19",
    revision: "cd5ff133f84854f0b269f5cb06193ad8205f05d3"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/WebAssembly/wabt/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "60d464680e3e70f9db8e079d1e6cb4d45f9c9994025cb3ba0f2b3a98c422f132" => :catalina
    sha256 "e19ec65d36ef68a8f5637dcc8d9728642fc0887e9f8655b912ec906c1e686d34" => :mojave
    sha256 "992e3b6ca47b54df5755d37e5968f15a2dda4070ec1f94d96c1e9a82828289d6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build

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

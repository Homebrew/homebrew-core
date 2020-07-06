class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
    :tag      => "1.0.17",
    :revision => "1467a6113414e7ef24174f51398079c9f4eeae57"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdb227c18043e0bb2beb7c1ee8010e725172e8e3667725d73b263cea00442479" => :catalina
    sha256 "b8084b828d5a15dea3c67b6a74420921a46ffeea7d8a7868384b0691d6e414e4" => :mojave
    sha256 "3e252aab05b7623daffc44967874ba0efa1ca1785004b99912fe0eb0898e1563" => :high_sierra
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

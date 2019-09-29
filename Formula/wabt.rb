class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/archive/1.0.12.tar.gz"
  sha256 "5333949ed4ae63808afa0d1f7d627cd7485ebeec339590571e5f2cb21e304f79"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1339d52cf0c351231d7e3dda70ac733746a186a4478641c9be00a790acc2d1f" => :mojave
    sha256 "2923d126a13d7075629d6180bbf4a79ca081f979a85e3386f88b4ed2e5efb5ff" => :high_sierra
    sha256 "6feb2399c260eb52f84f7d64ecb32e89b6e35c0e6b8ee124ec3968d424707109" => :sierra
  end

  depends_on "cmake" => :build

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

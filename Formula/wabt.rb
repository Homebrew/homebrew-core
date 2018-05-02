class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/archive/1.0.1.tar.gz"
  sha256 "720a1e68eddbacc2106d4db8056460488c96a7ff1bf0f5ec8dd8424f7a457ce4"

  bottle do
    cellar :any_skip_relocation
    sha256 "444169874af76461b42a4cd83a1e820c98c84957513439b48f0c8e603c15ab64" => :high_sierra
    sha256 "794a67ee327a8ccddc14ac2094d7d2aec1f995a3ec292620034b058522616f0a" => :sierra
    sha256 "d3a5b208d837de98a5c20e32ea8d07000eca435f205770f76647291db8724dee" => :el_capitan
    sha256 "9145751e84d336452310473de1cb757c8776e4e919a0dbc9cd63664c52dc7db4" => :yosemite
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

class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/archive/1.0.6.tar.gz"
  sha256 "62c04fe50404b494a5d8f78e9a991c72c97ab87c558b5ca1a52508b313a19178"

  bottle do
    cellar :any_skip_relocation
    sha256 "efb9416a4a4e8a998f9ec18c0c82b2f045afe3c3b09ef8caabe99fb6bd1999b5" => :mojave
    sha256 "d58d97a203abef2dbfbfc32c1eb8dfbdd50ba0c5277b40511a9b3361f02490a0" => :high_sierra
    sha256 "f6f3b20fa00c6c95295ba4ee5e0cbb84f87a70e33650e14d88887fbfe2ddaaf7" => :sierra
    sha256 "b3e1d1dd273319bc165b9e25736353298786709ec55d459b6390944fc856b8bd" => :el_capitan
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

class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/archive/1.0.11.tar.gz"
  sha256 "90e7f4a4e924e38af4edb6ca298ade662869c5b61a12399e71ee53d598d52cbe"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a26547c3ed9c126488363e48108ca4a78c5a7dfe3168c7a73451428d1f91941" => :mojave
    sha256 "fbeea492743acdfd77f6c660e9893bc15a0c72f671ce63164b91198a7da8dc60" => :high_sierra
    sha256 "1193a22956cbad81a9581a023cf8a9db9ef59cb5f1c2c57fabca893566e96a3b" => :sierra
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

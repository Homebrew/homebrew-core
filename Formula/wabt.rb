class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/archive/1.0.6.tar.gz"
  sha256 "62c04fe50404b494a5d8f78e9a991c72c97ab87c558b5ca1a52508b313a19178"

  bottle do
    cellar :any_skip_relocation
    sha256 "53fa692681e9730178bdd2cbfa6efeab8b2d7b589c239fa676ab6c32a93e6f7d" => :mojave
    sha256 "025c2420c8f8dcc85ce1114f652fd186c797ca4fb7f1c0027dd464a922d45d81" => :high_sierra
    sha256 "b4ff2cf3e9d106b4b3a1a4d77c3f662aa0c94c1dbd48d4aeefec8e9ec5c55e23" => :sierra
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

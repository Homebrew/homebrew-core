class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/archive/1.0.8.tar.gz"
  sha256 "ffaad6de5cfbc5be0c7e78ccd4c0b44bbd1e59eaa38cf50f4245ca04dbda883e"

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

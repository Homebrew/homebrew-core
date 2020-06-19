class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
    :tag      => "1.0.17",
    :revision => "1467a6113414e7ef24174f51398079c9f4eeae57"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f3308de6a50fe5bd1752ce05cd163909e1fc859d861dd58173cb5157b7196bf" => :catalina
    sha256 "0b896c75b31a4a98049b1c09575adb59f43caec21eb4d8f0c64c36e01ba29b48" => :mojave
    sha256 "163983a8850a98a297732be50f5e3c74dc39be63a66e0aedd2f866196651bc48" => :high_sierra
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

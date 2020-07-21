class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
    :tag      => "1.0.19",
    :revision => "cd5ff133f84854f0b269f5cb06193ad8205f05d3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9892df1b5c166364531062122dcf57d4c8c5ee0d5c4de7a14491cf6381bf25d4" => :catalina
    sha256 "90fc2045132ac96eb990f035e58be165122c1f12b72a2ba29aee06ff2e163775" => :mojave
    sha256 "865036f061c67f92c8ab2b1dd20827e3e21f41b982ec05e960627eb39c221eda" => :high_sierra
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

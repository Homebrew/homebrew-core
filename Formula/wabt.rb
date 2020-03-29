class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
    :tag      => "1.0.13",
    :revision => "7c80d05e37dc02870c680869ae3f04ac6d9637ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "11975b7122f6106a969064cd684e9a77d24443df26b873a225f48d8e1304fff9" => :catalina
    sha256 "26d32821ca26815974d699a5665ce3406fb9373a9d8970d7349ef6e3aee18208" => :mojave
    sha256 "5d028ba6b144571da2407e65351aebd93fabb84d453601971a4c5c02d3a51b17" => :high_sierra
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

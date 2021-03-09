class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.21",
      revision: "bdd7059ce7c5bf09b2a830f6cd5e15240d438a6e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7929c1f87382bdd1c8916ce884316f2f66c019066e372ff8b3ddc2635f2b80e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "71f8e4e4ec0571b7f4186a639513dc9a7fdd3980c55ebbe7e26dd8702e9d6069"
    sha256 cellar: :any_skip_relocation, catalina:      "b33133931248f3e603e39e5f195a662a2a3d413b49b0e23d4287e5297e87d21e"
    sha256 cellar: :any_skip_relocation, mojave:        "247e80525e30121e4fbcfa7431f7f50166456ce147e67e0e45ee5a1d73e66f12"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

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

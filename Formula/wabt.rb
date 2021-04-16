class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.23",
      revision: "aa0515b3c808da880942db8658abeaa969534667"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5e16ca1de51c071cd1d108910a1a50d971e97aaad3b39a11bbaeba4bccd33912"
    sha256 cellar: :any_skip_relocation, big_sur:       "1959b595f22d04838dd07219bc8cc46411bdad9c20affac93ecdd9c27cb44ee2"
    sha256 cellar: :any_skip_relocation, catalina:      "a7a055c375420d68e9a30f65e51217dfe734f090efed87f28fb8409ec60d91e0"
    sha256 cellar: :any_skip_relocation, mojave:        "1ee1d8c3f49f3052466387aaf07e81f20e2d9af7ab4a5c9b7ea35330c2ce195f"
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

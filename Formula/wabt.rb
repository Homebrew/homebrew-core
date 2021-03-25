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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b087005390228a32cec6a572e977baa497a16a6316d2064f6319a406e8aba9e"
    sha256 cellar: :any_skip_relocation, big_sur:       "12a054364d20466125b3a44837e61cea381e338ab52f39fec39fd1620821aa4d"
    sha256 cellar: :any_skip_relocation, catalina:      "194483f64d7cbc55867fe2a28a212b68d178ef54ee71f3aed821f3fed4ec2f6c"
    sha256 cellar: :any_skip_relocation, mojave:        "3357aeea2079d849c26feaef863a5ffa527aa2c054cf813ad25d6afc116cf118"
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

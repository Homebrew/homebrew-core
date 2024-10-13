class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.36",
      revision: "3e826ecde1adfba5f88d10d361131405637e65a3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6d9c47a7d54935eb10ec2dcf66c0c265e27f348cdf3e62b674debdbe2e3b6f71"
    sha256 cellar: :any,                 arm64_sonoma:   "6237a1e991c6fd3ef13205d461352614079623eff66d4d3b789653b2f6ad62d0"
    sha256 cellar: :any,                 arm64_ventura:  "e803c52ce80a02bb1f25f7ff14a84efc6aba0873e6d0349fbb3ceb525fdbebf2"
    sha256 cellar: :any,                 arm64_monterey: "c7c06f7d146ed9921827c24b163619793d5ed37fae1ccd7119c04edaf4fc119c"
    sha256 cellar: :any,                 sonoma:         "8e21afdc77664ee9790f575dc5e1e1b37432a04e78b60c99bd7964b35101e762"
    sha256 cellar: :any,                 ventura:        "df218de107e9a4961f32db86ad0e3cb28120d02ef551f6e298e39549ca14e230"
    sha256 cellar: :any,                 monterey:       "a3f76262eae5db4e8592817b256b27176a8fcf59f05d4a69b71cb617ed4d2c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183381abe48031239a58680b7991463788a018a456403f5061b783fe01b307db"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-WITH_WASI=ON",
                    *std_cmake_args,
                    "-DFETCHCONTENT_FULLY_DISCONNECTED=OFF" # FIXME: Find a way to build without this.
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system bin/"wat2wasm", testpath/"sample.wast"
  end
end

class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.12/solidity_0.8.12.tar.gz"
  sha256 "c63c2caf64feaef9fbde7c8d26e3d15aa9b159d08e7213e1e6bd3e4fd06c8308"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "533839ffdb47be227ae34e60ba5dc4fa3182090a85660031c331a6e4034aa2a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb82eb1a155be0c6a78667227e5ba386cec812dea664399b09db5d115ae5e05c"
    sha256 cellar: :any_skip_relocation, monterey:       "bf3aef8e9ed9509d24220972d7823a8aebf6114634270aa56b8ea46b9be4358d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1a7f390428da992eba7e6458b9a3807b153338e9d9da8ba61378c89dd1bbe8a"
    sha256 cellar: :any_skip_relocation, catalina:       "de208c309f9523429b131f7e77db781b5312ff8292da36c72f1c7c91e3b5ef88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e888794f4e7602bf008cecd4051d77b15202eae3617fa504566e6ed2fcd8a8"
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.0", :build]
  depends_on "boost"

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.sol").write <<~EOS
      // SPDX-License-Identifier: GPL-3.0
      pragma solidity ^0.8.0;
      contract HelloWorld {
        function helloWorld() external pure returns (string memory) {
          return "Hello, World!";
        }
      }
    EOS
    output = shell_output("#{bin}/solc --bin hello.sol")
    assert_match "hello.sol:HelloWorld", output
    assert_match "Binary:", output
  end
end

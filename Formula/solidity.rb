class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.2/solidity_0.8.2.tar.gz"
  sha256 "f4c51cd324ed580655001abde65540a7957138b43a4427dfbfc5f6fe72a57ac5"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44efb99d6787e83cb1b6620589235fd1ec299be7945723853219bec252c3685f"
    sha256 cellar: :any_skip_relocation, big_sur:       "79caffe640b66a9a86cb4c4e588b1abb2bc3981bd5b4e596a8519d32fe8d1518"
    sha256 cellar: :any_skip_relocation, catalina:      "06a8ab0f0a011c34c00ba14e9e6ef720e59506b3ab61bf33d9875af5b78a037f"
    sha256 cellar: :any_skip_relocation, mojave:        "2c50dfed7fd42ad2a87969effb02687671fd58e930d7dc0ad4944cb23601f738"
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

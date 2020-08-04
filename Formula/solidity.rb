class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://solidity.readthedocs.io"
  url "https://github.com/ethereum/solidity/releases/download/v0.6.12/solidity_0.6.12.tar.gz"
  sha256 "214bd37867d59c0f2f22dbaf10fd8eea2a58c9055c853c5016d26ad7091d5776"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdc25fe91c43bdfe39cf0c49f7729bf5968bcf8bda5613fed5c0c7a49d3019d7" => :catalina
    sha256 "feec8ba23058fe088ac1cfcebadc0151a519382921d5b65514193e8421bef61b" => :mojave
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.0", :build]
  depends_on "boost"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.sol").write <<~EOS
      // SPDX-License-Identifier: GPL-3.0
      pragma solidity ^0.6.0;
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

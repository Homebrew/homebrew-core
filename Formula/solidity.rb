class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://solidity.readthedocs.io"
  url "https://github.com/ethereum/solidity/releases/download/v0.7.0/solidity_0.7.0.tar.gz"
  sha256 "86e782a88eaaf4aa98f4e1e915f46b5bc5f596ea86c784fb911dc6e4c04309bf"
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
      pragma solidity ^0.7.0;
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

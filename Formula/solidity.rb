class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://solidity.readthedocs.io"
  url "https://github.com/ethereum/solidity/releases/download/v0.7.2/solidity_0.7.2.tar.gz"
  sha256 "71628cc4ad19500e5f532819b4c8bc241040032c7ba9a635ee51a5c8fcf480c8"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  bottle do
    cellar :any_skip_relocation
    sha256 "82c08040ddaab8989960f89de602ebe5b7b890b67ae081aa16f7d304f2273d52" => :catalina
    sha256 "f6d741893302638e028a59ccaaaccabc02e3b1f42655df5484a9d0063f4aaa7e" => :mojave
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

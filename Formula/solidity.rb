class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.0/solidity_0.8.0.tar.gz"
  sha256 "5a8f9f421dcf65d552b2e6fea4929aef68706a8db8b2e626e7a81e4e5ee11549"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4af825a080afedf57d0bae5664e09d12d8169082df6131527f7af3844ae7ccf2" => :big_sur
    sha256 "76c32257372ae1283395574a839cad3b684f737dbe7f34d911e9b659f21781da" => :catalina
    sha256 "ca2f5a36270ee10a683fdee22db467a1699b898748aae1665e5c23a36f0af5cc" => :mojave
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

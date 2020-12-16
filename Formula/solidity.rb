class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://solidity.readthedocs.io"
  url "https://github.com/ethereum/solidity/releases/download/v0.7.5/solidity_0.7.5.tar.gz"
  sha256 "b0b0f010ddcd7d77dc78fbc0458001476a4d0fc2d325a7a26208fb357ce5e571"
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

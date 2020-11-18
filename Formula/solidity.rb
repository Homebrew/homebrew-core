class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://solidity.readthedocs.io"
  url "https://github.com/ethereum/solidity/releases/download/v0.7.5/solidity_0.7.5.tar.gz"
  sha256 "b0b0f010ddcd7d77dc78fbc0458001476a4d0fc2d325a7a26208fb357ce5e571"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url "https://github.com/ethereum/solidity/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0f734a84af80cf2dcdc7d9b9600d3c9de2d5199f226c138b0516db2b21fbe893" => :big_sur
    sha256 "f5f68c1744f923e5e0028ec4380d9367174a8dd5cd48077d2eb8bea324ebaa16" => :catalina
    sha256 "2f07f797743f244ae63c0546ecf5c040f7efe8aeb03779c73c8a22935364d672" => :mojave
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

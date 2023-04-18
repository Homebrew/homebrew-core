class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.19/solidity_0.8.19.tar.gz"
  sha256 "9bc195e1695f271b65326c73a12223377d52ae4b4fee10589c5e7bde6fa44194"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "742ae6d3896895c53b571cce3ee7b96cf0ac6fb82b8705cca18c16306d99687f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16654e1e0c258b4484eca8ab746bcb4a48aac9dc6f40502d912656a854d489b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2e79896e0080242e6ab29532a1b6991dcfe38770f63653ddb49f4df38ec1053"
    sha256 cellar: :any_skip_relocation, ventura:        "2dbadf9f5b6b053298e57fb55da81ae5f8f77ee3c8d87258ccbcb84c95746008"
    sha256 cellar: :any_skip_relocation, monterey:       "4876889c3156d26a0d4b367aa7c2865ab608b52ec210ec3e056cb0de816337a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0b1768b368457d748313e72cd7eb601dec0dd787b76e96e4e89a70a075a54c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7caeb1de03ae8d3c55e7ab4df47cb65df1bc0d01ef5c773c8b3658a53780b138"
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.0", :build]
  depends_on "boost"

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

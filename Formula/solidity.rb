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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf4d611e30e5d0110ba63ed00438bc2f8e99292f8eddab7dea1d216e2f3e5e1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14a2b6d00f3c1475be7fb8eed298073722f8539b115bab4924fee23a298069e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fea0835c2a2a3ad41dc594a3963d9b299c72e39325bc1b84c089982a34a4e2c"
    sha256 cellar: :any_skip_relocation, ventura:        "e4cd385e10da69d2cf68212fd899a6965191f8e25df61cad44d7590a152baa42"
    sha256 cellar: :any_skip_relocation, monterey:       "811a27b223f3245914d09d7b9b93d22b9fe4914dc98dfe99f9caf0feb14e98ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5ff09486cf1174687b55239ff3f661686dbc460624a8214088aada2bd3ce526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa12d9487a34198cdb55f612a873e6b39c2800fe19ac796d0511439cddd1e349"
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

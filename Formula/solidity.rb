class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.1/solidity_0.8.1.tar.gz"
  sha256 "b28b2af228ca583efe7a44b18a622218df333962dce26edaa1d5dad9b1a60d47"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5aec17d05049a752a8f4dae6fe72c92e451c4da260e11f5fe4d56d2a12a5e1cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "96da61f3369a801b5339981dca3b3fb2d85c659de760a85d6ad4e830f0f13f7a"
    sha256 cellar: :any_skip_relocation, catalina:      "12298e172ca65370faf7c73b735a4f3b93911808dea765830bd6345ebc4a55d8"
    sha256 cellar: :any_skip_relocation, mojave:        "3ad5b0dfd289dd809b1d5637220c943dc809f682690685bd5811a56662412525"
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

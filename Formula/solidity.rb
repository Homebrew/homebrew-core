class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.5/solidity_0.8.5.tar.gz"
  sha256 "f754319ba5c82d6270a1add85f57d0580b875853885a76ec0c3b7025ec9e2d7c"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d570fae1663b46e7242035926418df432517f982b4e3fabf6b846e6d71dac9a"
    sha256 cellar: :any_skip_relocation, big_sur:       "33db942f3c5ba0b9fa9d1c0310ac882d523385d8fa3443779a1814a3119d6250"
    sha256 cellar: :any_skip_relocation, catalina:      "d00ae4a90211b92882ccf03e8125635d94dae7bbb5642d3040e401c1233d00c0"
    sha256 cellar: :any_skip_relocation, mojave:        "0f48a637c96de531f04bf14ae403fea0779ef93f2dc4db6f2d94a95448459d44"
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

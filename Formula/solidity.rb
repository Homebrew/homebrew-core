class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.9/solidity_0.8.9.tar.gz"
  sha256 "36643d0282998136b610f740808acb4dc6728144bb9ee70e5fd4124cda85ddab"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9067a3ad9a391e5b44aebe95698e4c2a1dbf2a7ef9cb4d691f82ca161a14d4e"
    sha256 cellar: :any_skip_relocation, big_sur:       "67eec440aaadb1bfa3b3e79adcc98595ccf4b20a330815463520a066c9e9d44b"
    sha256 cellar: :any_skip_relocation, catalina:      "27e39f6e750a012dcedab5d7203e6a6a9d905fcada819345a2d1d35365f0f06e"
    sha256 cellar: :any_skip_relocation, mojave:        "c1f61c3aaa6a0652d4cba95ebda4d7c4919f30f7ebea70ffa1223dc1092bca54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90664bc09fd6a7836c6cff3054dce6eba730c3643c4f7ac19addcd840acbec24"
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

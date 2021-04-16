class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.3/solidity_0.8.3.tar.gz"
  sha256 "8eeb520d5f80cd959517f0f164848ae7db0f11da1565ba376a15e9959185f383"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9e14b7662b1bf142c4bedf876633f261afc9876d5822a6d2d34500b9ac72cb5"
    sha256 cellar: :any_skip_relocation, big_sur:       "7cd1007da822738130e3443313e7d1d61bc890d2b791017b624da8d7e26149ec"
    sha256 cellar: :any_skip_relocation, catalina:      "8f45698bb0cc746f22b643e27b9debc3a4ea7b05f94c2b5df9d3004a9647b812"
    sha256 cellar: :any_skip_relocation, mojave:        "281a83ce5d87f99d740ce988eda7c4950d10c000884f022d3f23d702c5f9709a"
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

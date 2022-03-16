class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.13/solidity_0.8.13.tar.gz"
  sha256 "474c76b30f6de12e1d84171d094a110f4a9dbee8e110313de430e7ebabccb3da"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff19ef72faf15d7e66a2b5a8e5eba7cbc45d5932bfa930908d27a7d1134a9ad0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dae31579d457d92271e73e93ae025e6da5df7f95cc320718ff105b11fc2dc58"
    sha256 cellar: :any_skip_relocation, monterey:       "8d79a24c017e5ecd62dc4915f425b998b66bcb93687c0a94447798dadd3c4a3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a20165432bc6427d7ed5fc7be7eaf04726426a18d5f6917433a5a6968fbed28"
    sha256 cellar: :any_skip_relocation, catalina:       "fa769d055d709fb4bc7ebecd20766688fd057a02fc685062b4d8f1c73bde9c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a256d7054e7eaddc8630fbb87fc5e813667ef41a6e84386cec0457789a494028"
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

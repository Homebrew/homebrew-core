class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.30/solidity_0.8.30.tar.gz"
  sha256 "5e8d58dff551a18205e325c22f1a3b194058efbdc128853afd75d31b0568216d"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "473fa776a7d59bcddcd39fcae1decae308a7fcf76b955ad737788edb788dd1b1"
    sha256 cellar: :any,                 arm64_sonoma:  "1fff4b5d4ee6fdfe9f580cb4a0f9102a335c01c3e9cb9b43907b2904e1d9830d"
    sha256 cellar: :any,                 arm64_ventura: "3056f30a88cf1eb1283ca37ee98d52a3b799f49cc4da481161ff4f5bf6f717e6"
    sha256 cellar: :any,                 sonoma:        "5c54b89ae94ff561cb13ae3f1a5614a9a0996a1101602aa68fd6d911b8cb05c6"
    sha256 cellar: :any,                 ventura:       "754784a2bf9a57e6fe88d57c43465af5a721667250faf7767e817421438c4a13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9d10fb6a132c5d5f5b36ef1c9296ad9f4c25a2236822e054150ac057f72154a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e88792a9be5d50f8732d8679c3fba67b84c9ecc839e9af1bcd114c4fcb543111"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "range-v3" => :build
  depends_on "boost"
  depends_on "z3"

  conflicts_with "solc-select", because: "both install `solc` binaries"

  def install
    rm_r("deps")

    system "cmake", "-S", ".", "-B", "build",
                    "-DBoost_USE_STATIC_LIBS=OFF",
                    "-DSTRICT_Z3_VERSION=OFF",
                    "-DTESTS=OFF",
                    "-DIGNORE_VENDORED_DEPENDENCIES=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.sol").write <<~SOLIDITY
      // SPDX-License-Identifier: GPL-3.0
      pragma solidity ^0.8.0;
      contract HelloWorld {
        function helloWorld() external pure returns (string memory) {
          return "Hello, World!";
        }
      }
    SOLIDITY

    output = shell_output("#{bin}/solc --bin hello.sol")
    assert_match "hello.sol:HelloWorld", output
    assert_match "Binary:", output
  end
end

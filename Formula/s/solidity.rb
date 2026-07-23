class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/argotorg/solidity/releases/download/v0.8.36/solidity_0.8.36.tar.gz"
  sha256 "458c525af3a7bc1b5599e1a125cce960631ab8b3e7110c7ed4c9bbf34157fb86"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f8ffba8359791933c830ab98271cc38b045dd3051b8c424c88d6d64a4a3e7379"
    sha256 cellar: :any, arm64_sequoia: "fe5610708be2b877fb6f3d6b48b7a095f716bcf832d5868e9be6c277990aef5a"
    sha256 cellar: :any, arm64_sonoma:  "38ba75bae9aa03259f9d93b4959b8d719214bf2bbbd3d54c028c63d34f4b195a"
    sha256 cellar: :any, sonoma:        "4d660bddee914001521ff230392aac13afa987cba25cff2f5c68991446119d90"
    sha256 cellar: :any, arm64_linux:   "7b2090c679da018c31ecc9bd61420c0409a32ff0cbcec5b9cf7a6a538be44c3c"
    sha256 cellar: :any, x86_64_linux:  "2b492046a911046789aec46ef53f0cf42a981000a59ff5824608616e3cf47127"
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

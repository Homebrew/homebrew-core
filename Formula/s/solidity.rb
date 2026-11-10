class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/argotorg/solidity/releases/download/v0.8.38/solidity_0.8.38.tar.gz"
  sha256 "a96f89d20525724acd9717032a0315466078c0176d5d13016d81f4cc81fd4115"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7bf8b278ce33bf766d7ae105fcf204f15fa7fcd51da620ac45d038197ac2721a"
    sha256 cellar: :any, arm64_tahoe:       "72d189a4a4ac38d26baf2f0e15de1357334ac9d75d3fac664d51dde2054162ab"
    sha256 cellar: :any, arm64_sequoia:     "5966dc9899cac1ae2f1ab73dd6c8feea7a421569ac2bbdb1be532a1cf7d27988"
    sha256 cellar: :any, arm64_linux:       "c08a9bf758eba251b025af3e399b3dc45c57967e4f9f9c5773a921e022ce7696"
    sha256 cellar: :any, x86_64_linux:      "05e8d424ce57c39ab363a298b0945ddb1fc4029f62b55e8f893a0bc8d7c44d4e"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "range-v3" => :build
  depends_on "boost"
  depends_on "z3"

  conflicts_with "solc-select", because: "both install `solc` binaries"

  deny_network_access!

  def install
    rm_r("deps")

    # Avoid using an older deployment target than our bottle
    inreplace "CMakeLists.txt", "set(CMAKE_OSX_DEPLOYMENT_TARGET ", "# \\0"

    args = %w[
      -DBoost_USE_STATIC_LIBS=OFF
      -DSTRICT_Z3_VERSION=OFF
      -DTESTS=OFF
      -DIGNORE_VENDORED_DEPENDENCIES=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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

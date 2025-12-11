class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/argotorg/solidity/releases/download/v0.8.31/solidity_0.8.31.tar.gz"
  sha256 "1efcf5af92e39499ce64d9cb33ba1cc1aa43d0aba107472915d732bf4a31c837"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a20867ac3db8f7c225b457e22a40c3e6d760c813dcb32f91bbc769454e79251"
    sha256 cellar: :any,                 arm64_sequoia: "33f5d3ee79761ea972a9d78e68173d889392ebf8face77d2378c91a914372ea2"
    sha256 cellar: :any,                 arm64_sonoma:  "48e4852290432359850f67bdca49e0b57cef605e5f30608b3a471b418fad35c1"
    sha256 cellar: :any,                 sonoma:        "20a127dc1a3dbbc4dd15772415ddc0059e554241d30e528dabdd24bf1ff6e6e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "604223dca6a686c1f0a66f3d5866b3efef091dcc37c419e79ff089fc37c6bd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61188abccdc6c3ff34cbf1b19f0e12e0f60f7eadd2bb2d761f0adb67fc8e7853"
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

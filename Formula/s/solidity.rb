class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/argotorg/solidity/releases/download/v0.8.35/solidity_0.8.35.tar.gz"
  sha256 "76178a2d5ba92f08b6faa109fdd452a3fbe05ca610a43fa2f1a9426deda7e191"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd725bd70eea7bb4d916ba9e1f8ac41ed2047c93c6cefc4d3ab7f0bee12cfcce"
    sha256 cellar: :any,                 arm64_sequoia: "e3037ae235e65c8c92c6de206b604bca8d0f780884402f4c2a8decc1a285d4f9"
    sha256 cellar: :any,                 arm64_sonoma:  "a13a0989c50011dab49a1f5ada54d421046bcb4631e50d2e63f43eae9e8e7f54"
    sha256 cellar: :any,                 sonoma:        "3d56154e7421ef86a0502a7151ac453d8a78904c2d5e50b4c68bffe23f470db2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "448c14dc142ede41a53bce5c447230ae3b6595ce376f2208196ccba6e1d82bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e6fa375d57473ac08f1274da84c8a75763011ea49821388bc4ced7364678306"
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

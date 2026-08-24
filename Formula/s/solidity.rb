class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/argotorg/solidity/releases/download/v0.8.36/solidity_0.8.36.tar.gz"
  sha256 "458c525af3a7bc1b5599e1a125cce960631ab8b3e7110c7ed4c9bbf34157fb86"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3a8870e23c3d7ada3e1e55618d57337e88ebc365e061945ea1c92cd652b27f38"
    sha256 cellar: :any, arm64_sequoia: "d4bdfdbde9e2f2bdbc3d172e8b659c4fdafb6d570caf8c234e526f7631e1e19a"
    sha256 cellar: :any, arm64_sonoma:  "9473734f9ceebdb670c5f66cb5db824523442e2fe38e9563288d21c9795a53e3"
    sha256 cellar: :any, sonoma:        "4cfc61e53d82f08cd45a13852f7f1f87c358aa2e8beea118a107f0a728f34b5c"
    sha256 cellar: :any, arm64_linux:   "cc4e73430a6ed78c805b953d1520db5996bb5ba51ac01cccc46926bc372a3768"
    sha256 cellar: :any, x86_64_linux:  "821821ed37dcd107fccd3480a6bb862b4ca81cdeb82c4cc0e448731c2b9330be"
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

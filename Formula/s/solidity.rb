class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/argotorg/solidity/releases/download/v0.8.34/solidity_0.8.34.tar.gz"
  sha256 "415acd0bfc87a12e3c436fb439aabc62639e7a66d433450f0135a23238b4fc7e"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e3645a6ebe0c93c918472d8ec36ef17c3cbc34d3ed2aa271dfb675c9d5b0efb"
    sha256 cellar: :any,                 arm64_sequoia: "04f07924eefb08ffb28185e28fbfa04e094352822a9208b67ca3bcf4c70d1e2d"
    sha256 cellar: :any,                 arm64_sonoma:  "9db844da9da263eb4f87372ad95a981f61c7add74e0f9e79d4916cf3cf6e2f7b"
    sha256 cellar: :any,                 sonoma:        "4decbd94b65937c3474f4d165f5af5a4d4f5585e8532614ffb385e53f66c7a6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f103c5adec2f4ad20ba718d74164d359f018b643ca8ffe2567f5edd1b7c827c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17ac2f832e86cc676ba6db3c807b18098cf0c423e02ee352b1d0aec3ad26d9f7"
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

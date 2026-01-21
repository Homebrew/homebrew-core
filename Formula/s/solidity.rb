class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/argotorg/solidity/releases/download/v0.8.33/solidity_0.8.33.tar.gz"
  sha256 "2fb0a76b13e25b21bcd50607713a563f64709c8c283ed65464db3a2d546b9abf"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c79ca3f8f7d2dbd1843dea047ad266b82678d0ddf73d4b83785e76f1befb1c95"
    sha256 cellar: :any,                 arm64_sequoia: "7aa8c867524eacc5af4d90ac8b17c19600c36bd89563e957a9a973c565ade22b"
    sha256 cellar: :any,                 arm64_sonoma:  "1d3f58c0b040795e66244bde9abf23c3af4e3d462acf6e8084f3c836afef14e4"
    sha256 cellar: :any,                 sonoma:        "3890c867ec37fb10045044e144d3bb7400a660bd470465c5131a7d9273a16c56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe4908ab648ddddf55333dfe2e55355038ef83a44223464002166c8592a75d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eca4163211b680eec26f0b6ef2bdd828d39950b20f5db3f33960aff8dec860e6"
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

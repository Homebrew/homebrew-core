class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.29/solidity_0.8.29.tar.gz"
  sha256 "fe76237f513b7d6727a93cd5b83f92747650c8dc5f8f89457a41e8f54119ed38"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c4e75dcca9d33d11eb8268070850b20b4829677fabfef247c54dd0aeecdf9d4"
    sha256 cellar: :any,                 arm64_sonoma:  "3ac368ff5cebe1fa5128653f34c5c73703257694e2ef2e66b8874157e91edebf"
    sha256 cellar: :any,                 arm64_ventura: "4f22dff097bb4ca769aadb4132d3fef9634ae83bc2815d9d41d6e2a10137c08c"
    sha256 cellar: :any,                 sonoma:        "d2122a4129e2781aa5b2110e2b95655592f3052557d54e6ce0705338b348683d"
    sha256 cellar: :any,                 ventura:       "bf6500b6c763575d30fc2c0650c12f206995e4d39f957a16e9e1132dee278ab4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5df67fea4e2ed2663b268fcc7de13fd70e750b3037987cec832c06cf64d615c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "434f32192625362a4b50161e0972c5c930d21e50e5ff5a0eff4c151626d1a52a"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "range-v3" => :build
  depends_on "boost"
  depends_on "z3"

  conflicts_with "solc-select", because: "both install `solc` binaries"

  # build patch to use system fmt, nlohmann-json, and range-v3, upstream PR ref, https://github.com/ethereum/solidity/pull/15414
  patch do
    url "https://github.com/ethereum/solidity/commit/aa47181eef8fa63a6b4f52bff2c05517c66297a2.patch?full_index=1"
    sha256 "b73e52a235087b184b8813a15a52c4b953046caa5200bf0aa60773ec4bb28300"
  end

  # Support Boost 1.88.0, pr ref: https://github.com/ethereum/solidity/pull/15976
  patch do
    url "https://github.com/ethereum/solidity/commit/23587f9427bbd3d2147f32de5ede968c9c9aa133.patch?full_index=1"
    sha256 "d66489933a5c7ff71a72cb5eaa2426d3ff10dad494304c432c4a567ac4d42db7"
  end

  def install
    rm_r("deps")

    system "cmake", "-S", ".", "-B", "build",
                    "-DBoost_USE_STATIC_LIBS=OFF",
                    "-DSTRICT_Z3_VERSION=OFF",
                    "-DTESTS=OFF",
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

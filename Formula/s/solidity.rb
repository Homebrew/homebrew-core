class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.28/solidity_0.8.28.tar.gz"
  sha256 "ec756e30f26a5a38d028fd6f401ef0a7f5cfbf4a1ce71f76c2e3e1ffb8730672"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4f389bce0db912513f5e381a4bd139953f2cdfa82308d0a250f81dab088bd18e"
    sha256 cellar: :any,                 arm64_sonoma:  "8a1fa063bb9410e5257aceabd9c550c446e8906c258b3053367719413540371b"
    sha256 cellar: :any,                 arm64_ventura: "3a086cdb971d56700ca0d5c73580af511b3789b117de8cd4ff1251db233396de"
    sha256 cellar: :any,                 sonoma:        "ee728ca80234649a01096bd7f9fdf4bd64a8c70c1e7ad3fd160894bf7d24d112"
    sha256 cellar: :any,                 ventura:       "0c8159fe43ab0052660fef60240e41996becc36f76bb58fc47ab123931198835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f1142deb221472afbdad9b6042fc7967dc692a721b8a3b6d5c5f769279960a5"
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

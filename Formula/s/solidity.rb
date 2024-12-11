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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7d25ad2af2b0d23695ac400c5650d9f4b1ab381363c649f382b1763010362fba"
    sha256 cellar: :any,                 arm64_sonoma:  "fc412d6503e462724de89699c0b84c96944b349b88d222e37c9c38cea72c479d"
    sha256 cellar: :any,                 arm64_ventura: "5e579cf156f4878259a12cc70ccc7d300e6d6eb1a9e6822457df27185d3abd22"
    sha256 cellar: :any,                 sonoma:        "8e0726035c368da6bcd502d76b5139a668222de5b19f64787561500a0eacbd8f"
    sha256 cellar: :any,                 ventura:       "6fcd5c082015c863f527bb1983c72915f1c9a3f8b1d1ad0e27e2dbcb55e68561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaa64d53b22674a9afddd6bea5bb0c1f53bad7262ff6c98131d8ccbff989d791"
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

class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.30/solidity_0.8.30.tar.gz"
  sha256 "5e8d58dff551a18205e325c22f1a3b194058efbdc128853afd75d31b0568216d"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c942e9514c42b1b9e7c11f688bdfc3743996349d1560e898f5fff39019179280"
    sha256 cellar: :any,                 arm64_sequoia: "64d6eda62ef156a0101b7db05f46fced2dbb782642b92e3972689d87fa3ded70"
    sha256 cellar: :any,                 arm64_sonoma:  "d22c39245433eb7ce91fb21ea5d7587b5c2f0be56f5ea926d9d14274c7238536"
    sha256 cellar: :any,                 arm64_ventura: "5122f5b427213dbeecdbdc1f5e16d478d5577bfec406cb834d09dc0bfe5faa7c"
    sha256 cellar: :any,                 sonoma:        "1e776c872721c83f27fc64cf6ecee4a9a1c57660b7ca71be25b71e69c0d26e8c"
    sha256 cellar: :any,                 ventura:       "461812120f0c82b5e6ed4bda4c2e66c87e608762bda9e6a902f75b324874f72c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff393f0e988c7d12e0c26eaf7852a79382568fff3c2a911f17e14df692458b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "700199170a432f1e4a6608aa7e75c3def553578b0dbf8730ebb589a5e4a4f4e3"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "range-v3" => :build
  depends_on "boost"
  depends_on "z3"

  conflicts_with "solc-select", because: "both install `solc` binaries"

  # Fix build with Boost 1.89.0, pr ref: https://github.com/ethereum/solidity/pull/16163
  patch do
    url "https://github.com/ethereum/solidity/commit/1c6000917619c69feaa9fd14fe69c0445cc05f20.patch?full_index=1"
    sha256 "bf839570085ccd9baa227f30f91456f3ff72e9754d63019d33b34449bbb4c34e"
  end

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

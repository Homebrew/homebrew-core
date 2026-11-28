class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/argotorg/solidity/releases/download/v0.8.39/solidity_0.8.39.tar.gz"
  sha256 "2a5122f712c53fc58e9c243cdd4e0be6fe811c3111f03bdd6784bce066c48624"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "370e129c2a6a3b356db68466edd93315cdc30edb4d6010b123b4fe71b3c247a4"
    sha256 cellar: :any, arm64_golden_gate: "04ee28119d4aec70f23d15c7f502def53f36fd4ceb9fc6039fb5c48cab91b2da"
    sha256 cellar: :any, arm64_tahoe:       "dc3cee6fc354a49e5ae008e6c5f621a35a67ffaec0cda8d48f05b32883d6bc0d"
    sha256 cellar: :any, arm64_sequoia:     "8de7805c75c8b576eb26c975095443921bb0d43977a5f8bc4cda028eba5a387b"
    sha256 cellar: :any, arm64_linux:       "75543f39c4d5c66b6cd9d7a467e34e272ad60419c59963331f7d5b4062c18c82"
    sha256 cellar: :any, x86_64_linux:      "e90c867bdecb289ad140f09a5e3557f6dad2b88fad142db5b3249ab62257fdde"
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

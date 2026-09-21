class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/argotorg/solidity/releases/download/v0.8.37/solidity_0.8.37.tar.gz"
  sha256 "705306af6d6e0f4da04b4de7be22a5d7b87a90af0901170e726d8d97b342fcf8"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f6670235d9eca969a357efb5d2995e819000c05dde8d0173566a0b9f07596f3c"
    sha256 cellar: :any, arm64_tahoe:       "545a7a1683aa06d64d0c2a1d86192de77b6f5f414ee61c9f5782968cd6aa0885"
    sha256 cellar: :any, arm64_sequoia:     "4e0edcec1250896a4bb0b5810905c57a10fce130a28bb5d80e28f7bca663e21f"
    sha256 cellar: :any, arm64_linux:       "0c85b0e3e7e55c4b8fb527764d24c8ebd3a264082e220418c1c32848a9a521bd"
    sha256 cellar: :any, x86_64_linux:      "02bb12c5ad3307a601d2624084ef9856964d72ea21f1a0114d097813d0240611"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "range-v3" => :build
  depends_on "boost"
  depends_on "z3"

  conflicts_with "solc-select", because: "both install `solc` binaries"

  # Fix build with libc++ 22 (Xcode 27), which rejects the `std::less<YulArity>` specialization
  patch do
    url "https://github.com/argotorg/solidity/commit/7543cf45326f58d2597c9464d3d525822b6e28c7.patch?full_index=1"
    sha256 "d8bb9605e0b472eff8ba98e52d48d913d842d93e29b2348af9979c52901dbc4f"
    type :unofficial
    resolves "https://github.com/argotorg/solidity/pull/17027"
  end

  def install
    rm_r("deps")

    # Avoid using an older deployment target than our bottle
    inreplace "CMakeLists.txt", "set(CMAKE_OSX_DEPLOYMENT_TARGET ", "# \\0"

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

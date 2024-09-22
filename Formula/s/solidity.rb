class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.27/solidity_0.8.27.tar.gz"
  sha256 "b015e05468f3da791c8b252eb201fa5cb1f62642d6285ed2a845b142f96fc8a6"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "8f6ed45b502ea021bf9f39d34313051972ca1f87221d5123830f9cea301aae92"
    sha256 cellar: :any,                 arm64_sonoma:   "a560d6ec061b90cc311f53ebecb4e3c30e6aceef429acb29f8778da5c9eef23e"
    sha256 cellar: :any,                 arm64_ventura:  "c5361e4f5335b6dbf6757a363e2b7f406453cbd923fa4d5d00d9a0daa72e4fca"
    sha256 cellar: :any,                 arm64_monterey: "79e275db75e056304f7bf8e175d901bd3d03d1154b2db9932a9c8a9a92437477"
    sha256 cellar: :any,                 sonoma:         "eac228004196fb11830a34941b7546418a66b5cf5d817502c687102b43154391"
    sha256 cellar: :any,                 ventura:        "698999bf6cefa49d6ca4a7b031566de698e15e51fdfea60730054dd913481fbf"
    sha256 cellar: :any,                 monterey:       "84094564bcae094a0c352ccd734fd06e603968146fbdf2e8384a74d79e6de0df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e9df1f48006169ff62464f56e3d1b2c0ae3fa1176b0fcef39c6f8894485e665"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "range-v3" => :build
  depends_on "boost"
  depends_on "z3"

  conflicts_with "solc-select", because: "both install `solc` binaries"

  fails_with gcc: "5"

  # build patch to use system fmt, nlohmann-json, and range-v3, upstream PR ref, https://github.com/ethereum/solidity/pull/15414
  patch do
    url "https://github.com/ethereum/solidity/commit/aa47181eef8fa63a6b4f52bff2c05517c66297a2.patch?full_index=1"
    sha256 "b73e52a235087b184b8813a15a52c4b953046caa5200bf0aa60773ec4bb28300"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DSTRICT_Z3_VERSION=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.sol").write <<~EOS
      // SPDX-License-Identifier: GPL-3.0
      pragma solidity ^0.8.0;
      contract HelloWorld {
        function helloWorld() external pure returns (string memory) {
          return "Hello, World!";
        }
      }
    EOS

    output = shell_output("#{bin}/solc --bin hello.sol")
    assert_match "hello.sol:HelloWorld", output
    assert_match "Binary:", output
  end
end

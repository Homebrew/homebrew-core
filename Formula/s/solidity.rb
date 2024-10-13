class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.28/solidity_0.8.28.tar.gz"
  sha256 "ec756e30f26a5a38d028fd6f401ef0a7f5cfbf4a1ce71f76c2e3e1ffb8730672"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b9c156677e374eaf59be5495bb5e2762af577ff840149e388ec895d28b6f5cf4"
    sha256 cellar: :any,                 arm64_sonoma:  "5c9ed4e2f11cb81b1802f8f00a12d896eeed78fb3654f32a571b67c021d3753c"
    sha256 cellar: :any,                 arm64_ventura: "b5282e586af70de0dacfc75cb625226343bfdba1f6335890adecc91a106a6db7"
    sha256 cellar: :any,                 sonoma:        "2da60a4a743c85bb3e4d885ff96ed9db94df9076c7b565a9ba51304121384db3"
    sha256 cellar: :any,                 ventura:       "ac152d013a33817d9f0455d1f052a3d297ae4b0cb7070bcdfb6de7877ede2333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22896839ea9da3dd776292c755058b6e11fd1adb67fc23cf526addd10452c75b"
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

class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.7/solidity_0.8.7.tar.gz"
  sha256 "cc5be5d507604fb5c8a403f22122eabc00f8b58ecaedb18c6f4c6f28300a615b"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ef3e6acbd7295fb552f2343db5c227f7941bcf8f274e03ee6bdf57aeda5f849"
    sha256 cellar: :any_skip_relocation, big_sur:       "26422197d5607c144215f5f2210afe50903b3b5656b055f0dd2c8789aff5f9a2"
    sha256 cellar: :any_skip_relocation, catalina:      "e8e7023ca61135652f4e3d5b0f168079f4998333ab42a5afb7e42f7ef5c1e278"
    sha256 cellar: :any_skip_relocation, mojave:        "b7d42aff03cec1eba31984e051015decf38b6cc00af41419c0d452d0e962d47c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b7e4147feca7a07b597c008b577b1cc61273143cc2d81343213d29c89cc6216"
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.0", :build]
  depends_on "boost"

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
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

class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.14/solidity_0.8.14.tar.gz"
  sha256 "7ccdf20c889206103d0a48fe10b1c3f1f21269070861e80382f7ede8785e61d4"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa745b783b4671447bbb5d740353ba4768d715f294716e601d313316d205d307"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bbe9f1a774e11a6777051317668e2b63239f35ec48c9e9a5950b52794de198f"
    sha256 cellar: :any_skip_relocation, monterey:       "7f5e87469cd097c5b9ac0693ca57267d9c8260031c1b8b6732f8d1dc3b2881dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "16a6826e3c775d6cbc7332b29bbce7147840675822b5d35968672999f4f9cf40"
    sha256 cellar: :any_skip_relocation, catalina:       "f5cd7f5d70b62c0a3743e4b915b814bb8d223edf63032c896f8cee4daef0ed79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f1094454faf4d8ad3459694c649f640a58072bdf695488e1b5ec7af259ba3f"
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

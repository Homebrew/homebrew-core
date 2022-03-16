class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.13/solidity_0.8.13.tar.gz"
  sha256 "474c76b30f6de12e1d84171d094a110f4a9dbee8e110313de430e7ebabccb3da"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8addd110d2af1ad8a0e82624242c8262b319befe3e49473b5cf4db1320bf1f77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2365afe8589dcc1376cff46d6549b402a8efc466866da802254013690c3826e9"
    sha256 cellar: :any_skip_relocation, monterey:       "15a04ef618a25d01df6915d7901a1f2d37601d54d1ed0387d2b6721ff9b3b10d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9fdc61657d3687be642864b5cbe0a2d465a8b1787bb794060ec69353bc56021"
    sha256 cellar: :any_skip_relocation, catalina:       "b0aef2056a6b78df0b1ee6672584495f9db9abbe43cf9db1f9208bbc3e348ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e4ee74397fe329ab2a6bed482c4c22f75b197dd2de25f2b5d5c3e22aa480bfd"
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

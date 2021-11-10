class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.10/solidity_0.8.10.tar.gz"
  sha256 "3f157aa2bc8bcbd8975fe5e41c476b3d777432dfe7c64e9d59247ee225a89ee3"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d52228020e2d58c1698737f8d3051d29aca7bea59af0acd231a59cc2018b7f41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af37c87018dba48d0d665d1ad113ac8126c66a2ce5c4aa52aadb1609581df2da"
    sha256 cellar: :any_skip_relocation, monterey:       "5e29f0c490124dc43f0d9db5f2119f0c2338d76631f971967614d4babe9b23d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4226ba214336485fd23a90e2557db477b8e855c02bbe9e58f107b2e2ad1e1421"
    sha256 cellar: :any_skip_relocation, catalina:       "e6cf6d239c4f0be695202527b99b7b30860ce67078cc799f9e1af1756268fdbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27825ee32bc85b7a915378aec8cf470bb38718d0478b20b47898e9a5ef739fc9"
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

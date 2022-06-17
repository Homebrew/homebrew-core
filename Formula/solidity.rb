class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.15/solidity_0.8.15.tar.gz"
  sha256 "5720a50b3fa463afb90bf22c3cf5d2d8541b3a689bdb057da259fde88a472a49"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f308618d79c708fc20dde86dd0290c0720b4d79d599c45723c43b74b0833540"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c0789479044279818c63e772322767222d793c539d795bf7537f832357306e3"
    sha256 cellar: :any_skip_relocation, monterey:       "831d68c60972e17dc8a4459dd216e5844adb5e3654537955820b2399dd5dbc77"
    sha256 cellar: :any_skip_relocation, big_sur:        "056b43bad2d0945934ba4390b1f728fd7ec11dff1583c3ec65bd9e9922a952c9"
    sha256 cellar: :any_skip_relocation, catalina:       "d56203923ac9975791993b359ce8e871488ff75feb92e08d1f6020d1a5fc0d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c200f3c86602d369154d911c67ad4e684afb6270237d5cbef8b2e3b84361f2"
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

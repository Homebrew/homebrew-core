class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.21/solidity_0.8.21.tar.gz"
  sha256 "6d1bb8e72850320e72d788575f6bd25dd4930cb6dd9edd35a59266a46f610d13"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3ce41bb65420d367fc36871cb8eeeaa401b9fcb53996c72a8bb221003f84743"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c38b29827806be9182ba1b44843551f7eb36854a074b51af56b0b7e1bdb8738"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1918981bca20dc6d478b38a7fd103032d1637b1535b9e773a30b8706f9196e1f"
    sha256 cellar: :any_skip_relocation, ventura:        "289d29d6236ce84a00857b44edf2480754474e49dac5365848057a763d6b1005"
    sha256 cellar: :any_skip_relocation, monterey:       "82bc0cdc0afee2ed50c9e7c08f96c2a2b367c0df6e84233c15f34fdbaaa7bf7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffc4f49ef46582e5c0304b653ea8433c7daf0930f3429a259024c42ff23843c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46be35bc547de75f39379b21201c969fb332bbe658b08c5fbecdaceb24f9486d"
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.0", :build]
  depends_on "boost"

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

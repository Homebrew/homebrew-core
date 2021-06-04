class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.4/solidity_0.8.4.tar.gz"
  sha256 "4feb8f7dd3d1d3024000cf9b09d989a14fd92d65bf19b3c005842a0b809bc575"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "565735812a75a8099b5deaf539726a3cb46c3e0c5cdbc85e7f951e6ca9fd7afd"
    sha256 cellar: :any_skip_relocation, big_sur:       "db914ca408f79ba7aa3132477ad43b01053a3d41af810a0362c34ef287e366ed"
    sha256 cellar: :any_skip_relocation, catalina:      "aaa6137646ced7eabe52fbeb9e5429941b761c24b5d54446f19666edb40b1caf"
    sha256 cellar: :any_skip_relocation, mojave:        "b7936bbf08dcbc968be091b43922c5ed11072cd8e204fd66f5ad6a2f01789599"
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

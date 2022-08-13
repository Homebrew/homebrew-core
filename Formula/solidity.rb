class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.16/solidity_0.8.16.tar.gz"
  sha256 "ba1a690a3583f17c039e6d480970f687f959d9c0fcb2e77ac72a0a0c7efa2056"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "027f8cfe52cc40674e66d912f9d0670adb5c1a1b64d3dc98cd47290c85d3a080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "953f8ff3918fd3b5f1a48618fceb2ae1515f8b8483c854ea81317022105bedf7"
    sha256 cellar: :any_skip_relocation, monterey:       "e2bec1d08f27770dbf2d259ce99a19a2d11d21ebeae4b2ed2db2799144773742"
    sha256 cellar: :any_skip_relocation, big_sur:        "018432773ac3f3e5f82db4a822a4ed98878a3ea466a24d0a1258246f41aac7fa"
    sha256 cellar: :any_skip_relocation, catalina:       "7e5be18b7455bad8654b09cfd4797d3619693b3397ebb090cad766659d51c7ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53e81864be79cb365da8baf59cbacf71ce47504bb80fb9849a9d499d62784aae"
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

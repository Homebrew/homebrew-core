class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.20/solidity_0.8.20.tar.gz"
  sha256 "8a54043ebbd436b8b38d625d90ceb69dce07c150822fb6d796e440ccc2c17981"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06f93dae25f695b04128c4f18a41aeca30117b3d7e82dc3b3fb66a4008527faa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ed30c4f8cea1ea33cab347e6eeefe526cafe8dc58a478628ca4b97435641988"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03437550f65560247f5112a7d58b88f2ed51787865e4f7c603899c876805083b"
    sha256 cellar: :any_skip_relocation, ventura:        "4a05de06bb38045acd0fae3940c8fdf874f98d21a4c41e3badb7c5ec4d836393"
    sha256 cellar: :any_skip_relocation, monterey:       "24fd859b0c31a186adfa9fac1d492d833d83996e8569c8ed31c388b01c4a0afc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4103203e113ccb9db72d2a9bb20610a04c9be7961ac3fa5f360104c3606a4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "623cbfb66be219f306d3bb3c57d377b60e7d1b72374041c6da9cd44d9a2b161f"
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

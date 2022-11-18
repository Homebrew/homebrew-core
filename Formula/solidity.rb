class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.17/solidity_0.8.17.tar.gz"
  sha256 "b0337ab0125be7e54461ab76b6e483f5e912d3f3e4b0c89bd00cfb0a3d6a5afd"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d027e015f7f28edb42f9f59ee3e7fe4cdec90360bbb3d3811362b6d5f5c8880b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a44f2d497a1db10c796fc7833c2d166e53a2d441d75f0f03c56955d4267e229e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "275809d3b40b6470ebc0778f88cdc8921de593881e296370194b14f13652e348"
    sha256 cellar: :any_skip_relocation, ventura:        "67ccce445e18ae44a2dc75b336869e61f87c4c6b405819659996dfec54df9d59"
    sha256 cellar: :any_skip_relocation, monterey:       "5ce812a479c2164315250e4e6f970d646d0f268e646aff02c913e8e1da1e8fc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "92625da745854d006d18644647f1e93bbef87e5659596836fca1566aceeb9a89"
    sha256 cellar: :any_skip_relocation, catalina:       "be5c8e865737ee4cee363010e44362d6f7099d3cea5d9e395f081aac013aca48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "699bef7d67e8209d40b9cedc849df54106fdb8d7cad03c04d3940067ed7879c2"
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

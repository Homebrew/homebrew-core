class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.25/solidity_0.8.25.tar.gz"
  sha256 "def54b5f8385ef70e102d28321d074e7f3798e9688586452c7939e6733ab273f"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3776cf6c80f552616c7025f7bb0ee857d01c63c89c2169cf60587ca6941a6e82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "210dbfd88b6ae0ba2b3f866227a251cab6237e5007b282096f7ba47b83ab8e45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d082c76ece97000a5a225acc88ce0bb620053f7689ed9db4e76a710c775af9ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c485043bd2360ae0cd964f855ae46a580bf7ff233c984598a2d391d00ba20a2"
    sha256 cellar: :any_skip_relocation, ventura:        "90b739f4ea9b6d4f20efa6e29ef262dbdf219860134512c20798611a15664b75"
    sha256 cellar: :any_skip_relocation, monterey:       "772116893142a13db12d0928e3f751665e7ac1c0fcc516c866fa1d77713bc8c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13496bde08ca05a14cce4b80559b7f84823855e8f35fde72b06a35f02453bb57"
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

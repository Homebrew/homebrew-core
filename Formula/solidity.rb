class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.0/solidity_0.8.0.tar.gz"
  sha256 "5a8f9f421dcf65d552b2e6fea4929aef68706a8db8b2e626e7a81e4e5ee11549"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "721abd3121957e11cd39084a90ae3cf7a385a330745a13a6ee26e978348a94b6" => :big_sur
    sha256 "06b9c4deb734f35350fd3c7bb7fef169169c4d6804a49b5693f643b3213c98b2" => :arm64_big_sur
    sha256 "dfc15d2f00dca49304056340ae1363f403513c22ff05ff9a6dbd8b5135266170" => :catalina
    sha256 "5574a633f0cc5e629b46f5503f3ac34d077c5112efbeb3dbff0a64e054465380" => :mojave
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.0", :build]
  depends_on "boost"

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

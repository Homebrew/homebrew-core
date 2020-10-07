class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://solidity.readthedocs.io"
  url "https://github.com/ethereum/solidity/releases/download/v0.7.3/solidity_0.7.3.tar.gz"
  sha256 "3c3e03b659e57781d8dc73785404f04f33c44d0ca97bd218793cfab888c74180"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  bottle do
    cellar :any_skip_relocation
    sha256 "f859e3a1f2de70dd59b6850201ad2635f2a9a8e2fc43dcaa0f78b7ce9f80ff73" => :catalina
    sha256 "f0f96591dbb4bd6944a041c5807c61a983bdfb9452dc83d180c63fc365d10046" => :mojave
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
      pragma solidity ^0.7.0;
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

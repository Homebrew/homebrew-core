class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://solidity.readthedocs.io"
  url "https://github.com/ethereum/solidity/releases/download/v0.7.4/solidity_0.7.4.tar.gz"
  sha256 "3994482ed1104f55cbd7614649c2129adaf3fc9a782d910e688d0010abeb7a9c"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  bottle do
    cellar :any_skip_relocation
    sha256 "ca7716d324afdeb5e692b3b493b4ab3437e0498d12278ec73bc607bec9d3dc90" => :catalina
    sha256 "1fb2d31bc30782ab3525097d02ce398fbaaa7ada46e78fab6e120be8a30f03ad" => :mojave
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

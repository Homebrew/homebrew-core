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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eeea6357b0e56e9b3d61b06e3f106a4f4e05a739e7aa06dc25f4a578a341aba4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18a643543d666b36adf9d3c1bb661df1d1af444f5e17e3d8de151062d558c6ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91c9e20a8ec69b25f0c676b4bb7261ac61b3468afad2f2be2aab0e09d0e2d1e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c5b0be1472831e5c4917192e61912b63fbec505f71cc6168fa65ce05d87404e"
    sha256 cellar: :any_skip_relocation, ventura:        "50aa73de745049a354b68665f58c9a70338d470c76de790df2c308f52f95d428"
    sha256 cellar: :any_skip_relocation, monterey:       "e9235cd8aac9fd624ccd73400715f7629853901757fa6d77d7f6b9796e868bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56672c990c7a5b257fd7fc5d8599fbb6101a31d311a0df6cd6c677f37e3f510f"
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

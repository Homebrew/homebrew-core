class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-5.1.0.tgz"
  sha256 "a81a2bdbefa6f9b4918b5211a955ba37219db06474345dbfa2bb0a8fc47b43c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8838c345b0300720adcae400fd4c0cffb0e6845de7fa615230901e86131e9f6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8838c345b0300720adcae400fd4c0cffb0e6845de7fa615230901e86131e9f6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8838c345b0300720adcae400fd4c0cffb0e6845de7fa615230901e86131e9f6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1008a9f0bf0241dc5077bfb864f543f348e530bd15f92fe80f52a42442190c63"
    sha256 cellar: :any_skip_relocation, ventura:       "1008a9f0bf0241dc5077bfb864f543f348e530bd15f92fe80f52a42442190c63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8838c345b0300720adcae400fd4c0cffb0e6845de7fa615230901e86131e9f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8838c345b0300720adcae400fd4c0cffb0e6845de7fa615230901e86131e9f6c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_config = testpath/".solhint.json"
    test_config.write <<~JSON
      {
        "rules": {
          "no-empty-blocks": "error"
        }
      }
    JSON

    (testpath/"test.sol").write <<~SOLIDITY
      pragma solidity ^0.4.0;
      contract Test {
        function test() {
        }
      }
    SOLIDITY
    assert_match "error  Code contains empty blocks  no-empty-blocks",
      shell_output("#{bin}/solhint --config #{test_config} test.sol 2>&1", 1)
  end
end

class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-5.0.3.tgz"
  sha256 "dd26c50bb8c53e6869b424107012fcd20e109718fd40e9bbc15c6efa8c5863df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3057b556a4bade26f52280a96f9225b904eb72b896fc03b8fa5c2ca67ca1f23e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bcf8c9119a06cc86fa904103605f918a4f5c53a3ad14452c6d8eae2710223f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bcf8c9119a06cc86fa904103605f918a4f5c53a3ad14452c6d8eae2710223f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bcf8c9119a06cc86fa904103605f918a4f5c53a3ad14452c6d8eae2710223f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c61c21de99312d1f161f29e0d5fe723ac206cfe0850d0a75b71a04b3d50e67ce"
    sha256 cellar: :any_skip_relocation, ventura:        "c61c21de99312d1f161f29e0d5fe723ac206cfe0850d0a75b71a04b3d50e67ce"
    sha256 cellar: :any_skip_relocation, monterey:       "c61c21de99312d1f161f29e0d5fe723ac206cfe0850d0a75b71a04b3d50e67ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bcf8c9119a06cc86fa904103605f918a4f5c53a3ad14452c6d8eae2710223f8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_config = testpath/".solhint.json"
    test_config.write <<~EOS
      {
        "rules": {
          "no-empty-blocks": "error"
        }
      }
    EOS

    (testpath/"test.sol").write <<~EOS
      pragma solidity ^0.4.0;
      contract Test {
        function test() {
        }
      }
    EOS
    assert_match "error  Code contains empty blocks  no-empty-blocks",
      shell_output("#{bin}/solhint --config #{test_config} test.sol 2>&1", 1)
  end
end

class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-5.0.5.tgz"
  sha256 "dacb00c5a84b65b65370b8531480b1d25171dc97b45a246cf943ca8b4f91488d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5495db9fed240f30a1f879f597c6e4303ba3e69faa87da786bd88b3802bf74e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5495db9fed240f30a1f879f597c6e4303ba3e69faa87da786bd88b3802bf74e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5495db9fed240f30a1f879f597c6e4303ba3e69faa87da786bd88b3802bf74e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4f9024768d2cc9eaf52adf7a42d602f4cc4405a40814ca1c6c35b2cca5f6bd5"
    sha256 cellar: :any_skip_relocation, ventura:       "f4f9024768d2cc9eaf52adf7a42d602f4cc4405a40814ca1c6c35b2cca5f6bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5495db9fed240f30a1f879f597c6e4303ba3e69faa87da786bd88b3802bf74e1"
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

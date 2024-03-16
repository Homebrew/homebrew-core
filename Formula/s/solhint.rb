require "language/node"

class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-4.5.2.tgz"
  sha256 "a57318a4f78b62fe61b6ee342389c018325119055b209e7c9c41ccb03129d33b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c61954eebe4eb830529c713a222b6101dac88a6d528aff13313ec446052bf0e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c61954eebe4eb830529c713a222b6101dac88a6d528aff13313ec446052bf0e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c61954eebe4eb830529c713a222b6101dac88a6d528aff13313ec446052bf0e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "088c9dbdacff22a052490c2e553ccfd4a2b7ff8e2b10ed1da03e0e32ff933a96"
    sha256 cellar: :any_skip_relocation, ventura:        "088c9dbdacff22a052490c2e553ccfd4a2b7ff8e2b10ed1da03e0e32ff933a96"
    sha256 cellar: :any_skip_relocation, monterey:       "088c9dbdacff22a052490c2e553ccfd4a2b7ff8e2b10ed1da03e0e32ff933a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c61954eebe4eb830529c713a222b6101dac88a6d528aff13313ec446052bf0e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
      shell_output("#{bin}/solhint --config #{test_config} test.sol 2>&1")
  end
end

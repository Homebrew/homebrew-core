require "language/node"

class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-4.5.2.tgz"
  sha256 "a57318a4f78b62fe61b6ee342389c018325119055b209e7c9c41ccb03129d33b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54afd001ed52ed06b817582b09b2c883b0424957fa123e8ab9df789f94952b21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54afd001ed52ed06b817582b09b2c883b0424957fa123e8ab9df789f94952b21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54afd001ed52ed06b817582b09b2c883b0424957fa123e8ab9df789f94952b21"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f63d04927b0f0ec68329e8264e73b62aecdbff7d14c3340710639e9a120b6fb"
    sha256 cellar: :any_skip_relocation, ventura:        "0f63d04927b0f0ec68329e8264e73b62aecdbff7d14c3340710639e9a120b6fb"
    sha256 cellar: :any_skip_relocation, monterey:       "0f63d04927b0f0ec68329e8264e73b62aecdbff7d14c3340710639e9a120b6fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54afd001ed52ed06b817582b09b2c883b0424957fa123e8ab9df789f94952b21"
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

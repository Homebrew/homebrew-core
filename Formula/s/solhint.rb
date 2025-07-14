class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-6.0.0.tgz"
  sha256 "ac11b20749ee0fe428fbfe0078c1e652b3d038b8b7e8881d50c04dbfd1a2e27f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbd67f8b667451be10b15f86007454dcea3d5e456f6e0772b712b7e021b9fb3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbd67f8b667451be10b15f86007454dcea3d5e456f6e0772b712b7e021b9fb3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbd67f8b667451be10b15f86007454dcea3d5e456f6e0772b712b7e021b9fb3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3a2bff5ddfb6e5c7e1844b8b9aacf39a2c8c9438f4d652f5b09dffb70d687e8"
    sha256 cellar: :any_skip_relocation, ventura:       "f3a2bff5ddfb6e5c7e1844b8b9aacf39a2c8c9438f4d652f5b09dffb70d687e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbd67f8b667451be10b15f86007454dcea3d5e456f6e0772b712b7e021b9fb3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbd67f8b667451be10b15f86007454dcea3d5e456f6e0772b712b7e021b9fb3a"
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

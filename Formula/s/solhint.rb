require "language/node"

class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-5.0.1.tgz"
  sha256 "c44aad3d7b3e3d41c64af799744741b58392fac028f95aee50a1fd79af315a36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a28d0a4f80daea8a106b28669d0dacd22d080b023e65a93b36748e813d4d91f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfc8b1806f8fbe61da55b2938bb7d9b65705dbae1c313c2d36fa1b8f53780a59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b634335aa0dc5c67db90a25f333eca2b97d37f7d1a88fb1e53de85517ec32696"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9025605b253e8b6e131cbaf594d2d1b751939e9f4a465a7f0676dd2840b6249"
    sha256 cellar: :any_skip_relocation, ventura:        "c3beee10dd76be60aeeb3260e7017670bb19b116084088ad0ea782b7d1ddb634"
    sha256 cellar: :any_skip_relocation, monterey:       "3e3bcd51096fe79a92a669dc313c109c9e40eb8bbf7136aadff15eb78c1e1061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd811f57ccb4c3fb7308b9e762544e43a240f49233fa781d7f2044267c63d910"
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
      shell_output("#{bin}/solhint --config #{test_config} test.sol 2>&1", 1)
  end
end

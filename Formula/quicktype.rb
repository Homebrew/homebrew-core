require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.47.tgz"
  sha256 "7f3f758c98ad9814c5b8ef92c4afa57e68d914ef39ca8024f691ec18c842c8c8"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1439613376eede598324143194c1c499675cef008c4476fb9b671bc1af93f5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1439613376eede598324143194c1c499675cef008c4476fb9b671bc1af93f5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1439613376eede598324143194c1c499675cef008c4476fb9b671bc1af93f5f"
    sha256 cellar: :any_skip_relocation, ventura:        "147d644ec412e111117ca1a3aa2e576eb2f7dccbd298e09466ec90c16ce986e1"
    sha256 cellar: :any_skip_relocation, monterey:       "147d644ec412e111117ca1a3aa2e576eb2f7dccbd298e09466ec90c16ce986e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "147d644ec412e111117ca1a3aa2e576eb2f7dccbd298e09466ec90c16ce986e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1439613376eede598324143194c1c499675cef008c4476fb9b671bc1af93f5f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end

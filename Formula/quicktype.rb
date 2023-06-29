require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.48.tgz"
  sha256 "9135d3f032bffdefb8f3fb53ef2ffd202517f59128c79b994d3daab171a5f75f"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34e33c367e45e287f15533029d4966189fa13a6f5daf4f6944dfd99233937fc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34e33c367e45e287f15533029d4966189fa13a6f5daf4f6944dfd99233937fc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34e33c367e45e287f15533029d4966189fa13a6f5daf4f6944dfd99233937fc1"
    sha256 cellar: :any_skip_relocation, ventura:        "ffc55c486970f49bfd5efed7edde68b83016862b6fc4d9abc06bd3b2e3221643"
    sha256 cellar: :any_skip_relocation, monterey:       "ffc55c486970f49bfd5efed7edde68b83016862b6fc4d9abc06bd3b2e3221643"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffc55c486970f49bfd5efed7edde68b83016862b6fc4d9abc06bd3b2e3221643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34e33c367e45e287f15533029d4966189fa13a6f5daf4f6944dfd99233937fc1"
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

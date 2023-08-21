require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.71.tgz"
  sha256 "3a9b9c38880ed81af6c49886554d1ebd3ba710f17b0fd34090bf96c3360790df"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a51ff828648661687838509ad44193d13bc9521c4578b3a1e33f7d6e1d554b94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a51ff828648661687838509ad44193d13bc9521c4578b3a1e33f7d6e1d554b94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a51ff828648661687838509ad44193d13bc9521c4578b3a1e33f7d6e1d554b94"
    sha256 cellar: :any_skip_relocation, ventura:        "b0819ad4f0c4aead4ebe1bb2500870e2fc284c9b44f2962a9c45af70a9eda70c"
    sha256 cellar: :any_skip_relocation, monterey:       "b0819ad4f0c4aead4ebe1bb2500870e2fc284c9b44f2962a9c45af70a9eda70c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0819ad4f0c4aead4ebe1bb2500870e2fc284c9b44f2962a9c45af70a9eda70c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a51ff828648661687838509ad44193d13bc9521c4578b3a1e33f7d6e1d554b94"
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

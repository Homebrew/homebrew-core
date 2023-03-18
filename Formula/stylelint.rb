require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.3.0.tgz"
  sha256 "8fa19d8a8437525e24333e15e7dffc6d2bc33f49eb32b2d4559c80df95e72707"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30977b1891ef0b7cae92ceb39d94ed346f002b26f81bd0f631140ff40a2c651b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30977b1891ef0b7cae92ceb39d94ed346f002b26f81bd0f631140ff40a2c651b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30977b1891ef0b7cae92ceb39d94ed346f002b26f81bd0f631140ff40a2c651b"
    sha256 cellar: :any_skip_relocation, ventura:        "41e0512656a88ab57067001101c0841116bfc659040afbe337465582a0341e12"
    sha256 cellar: :any_skip_relocation, monterey:       "41e0512656a88ab57067001101c0841116bfc659040afbe337465582a0341e12"
    sha256 cellar: :any_skip_relocation, big_sur:        "41e0512656a88ab57067001101c0841116bfc659040afbe337465582a0341e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30977b1891ef0b7cae92ceb39d94ed346f002b26f81bd0f631140ff40a2c651b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~EOS
      {
        "rules": {
          "block-no-empty": true
        }
      }
    EOS

    (testpath/"test.css").write <<~EOS
      a {
      }
    EOS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end

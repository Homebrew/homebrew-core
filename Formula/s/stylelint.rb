require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.10.3.tgz"
  sha256 "8de9f620d6db5200d4d9cb1821b520eddca1ea0d2afd110fe05c39ffcdaaf851"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a61415e692378fa48489ccbf9e4efe1961f4b7c79ae0cefe54dfabe8379b751"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a61415e692378fa48489ccbf9e4efe1961f4b7c79ae0cefe54dfabe8379b751"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a61415e692378fa48489ccbf9e4efe1961f4b7c79ae0cefe54dfabe8379b751"
    sha256 cellar: :any_skip_relocation, ventura:        "7ecda50cf2b90cbc3219c296b93f3a56baa19b4e2208b51a353db9ccc29253c7"
    sha256 cellar: :any_skip_relocation, monterey:       "7ecda50cf2b90cbc3219c296b93f3a56baa19b4e2208b51a353db9ccc29253c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ecda50cf2b90cbc3219c296b93f3a56baa19b4e2208b51a353db9ccc29253c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a61415e692378fa48489ccbf9e4efe1961f4b7c79ae0cefe54dfabe8379b751"
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

require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.2.0.tgz"
  sha256 "5c2b04f5cb0fac612963b1f36e50d22ea4ec0a708720896ebd1e015f42f6903d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7247f7a26a2e5a33b13fc8c38e29523665e0ecf25310e8817fc110bb7db9447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7247f7a26a2e5a33b13fc8c38e29523665e0ecf25310e8817fc110bb7db9447"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7247f7a26a2e5a33b13fc8c38e29523665e0ecf25310e8817fc110bb7db9447"
    sha256 cellar: :any_skip_relocation, ventura:        "aad424ac59b194a668387fc6e9aaa1b1d9b2479343ba027b181ef4b15ea6bf6e"
    sha256 cellar: :any_skip_relocation, monterey:       "aad424ac59b194a668387fc6e9aaa1b1d9b2479343ba027b181ef4b15ea6bf6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "aad424ac59b194a668387fc6e9aaa1b1d9b2479343ba027b181ef4b15ea6bf6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7247f7a26a2e5a33b13fc8c38e29523665e0ecf25310e8817fc110bb7db9447"
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

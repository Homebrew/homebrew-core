require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-14.16.1.tgz"
  sha256 "f968356f0e32a7dab460703c1e795bb01c12a85f62258049100efa9af7c595a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10c93affde845bdc088c78bdc4dd03b436c6e39eaa08a2f4ded5d80b7af67840"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10c93affde845bdc088c78bdc4dd03b436c6e39eaa08a2f4ded5d80b7af67840"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10c93affde845bdc088c78bdc4dd03b436c6e39eaa08a2f4ded5d80b7af67840"
    sha256 cellar: :any_skip_relocation, ventura:        "343dacd002bc3c482afda871fe3dc29722b93ae296bc7b50f24bef3a4dd9f8a6"
    sha256 cellar: :any_skip_relocation, monterey:       "343dacd002bc3c482afda871fe3dc29722b93ae296bc7b50f24bef3a4dd9f8a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "343dacd002bc3c482afda871fe3dc29722b93ae296bc7b50f24bef3a4dd9f8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10c93affde845bdc088c78bdc4dd03b436c6e39eaa08a2f4ded5d80b7af67840"
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

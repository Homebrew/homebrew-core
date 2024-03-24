require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.3.0.tgz"
  sha256 "7e0acdb3546d4ecc8b9462bc67bd47030c57b294a4a3c43fac1a37ea69c72d48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1acaea439071344d8327f167aba0c8ca203b848dbe37dae4e7a273dd4095fbfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1acaea439071344d8327f167aba0c8ca203b848dbe37dae4e7a273dd4095fbfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1acaea439071344d8327f167aba0c8ca203b848dbe37dae4e7a273dd4095fbfa"
    sha256 cellar: :any_skip_relocation, sonoma:         "07a8f77880810d84b11f2de2b068c89746aba2e30cc85eaed1384fc56e0b1184"
    sha256 cellar: :any_skip_relocation, ventura:        "07a8f77880810d84b11f2de2b068c89746aba2e30cc85eaed1384fc56e0b1184"
    sha256 cellar: :any_skip_relocation, monterey:       "07a8f77880810d84b11f2de2b068c89746aba2e30cc85eaed1384fc56e0b1184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1acaea439071344d8327f167aba0c8ca203b848dbe37dae4e7a273dd4095fbfa"
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

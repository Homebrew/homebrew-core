require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.6.1.tgz"
  sha256 "3d1241ef08b8962b2c06e88ae3fd975c46f20cfb0d243c9b14bb0fb9372c81c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a37f7b140e14a3cc62b255f002733a7d68ded21f07e5324b5b3eacb42616dca7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a37f7b140e14a3cc62b255f002733a7d68ded21f07e5324b5b3eacb42616dca7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a37f7b140e14a3cc62b255f002733a7d68ded21f07e5324b5b3eacb42616dca7"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa9f38e3a1dd0123f93aa14d583cb9fe456f9be2b2f3f859f19010136edcfb5d"
    sha256 cellar: :any_skip_relocation, ventura:        "e9c69ca7f2ef878f51029c915fc2efc466e671a80ef16ae3f4370c6529738c03"
    sha256 cellar: :any_skip_relocation, monterey:       "e9c69ca7f2ef878f51029c915fc2efc466e671a80ef16ae3f4370c6529738c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec5a92057a19b8f4231fb076c9b120e5c8681e2a50348528c101679dba03cf8"
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

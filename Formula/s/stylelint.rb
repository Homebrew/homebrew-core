class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.21.1.tgz"
  sha256 "774794b549407b3f76be1a015643551a3abc5feb48a64a3b4d5e84f31dff23b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bdd7c17c11ff3f94851491243bc13d96d7f126a9b154108f867278360f8bc6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bdd7c17c11ff3f94851491243bc13d96d7f126a9b154108f867278360f8bc6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bdd7c17c11ff3f94851491243bc13d96d7f126a9b154108f867278360f8bc6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd1e7cbd75e777e88944d3602c693204a9b916f93ddfb46b7956a08369d6d296"
    sha256 cellar: :any_skip_relocation, ventura:       "dd1e7cbd75e777e88944d3602c693204a9b916f93ddfb46b7956a08369d6d296"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bdd7c17c11ff3f94851491243bc13d96d7f126a9b154108f867278360f8bc6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bdd7c17c11ff3f94851491243bc13d96d7f126a9b154108f867278360f8bc6a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~JSON
      {
        "rules": {
          "block-no-empty": true
        }
      }
    JSON

    (testpath/"test.css").write <<~CSS
      a {
      }
    CSS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end

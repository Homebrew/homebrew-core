require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.1.0.tgz"
  sha256 "82c6f4a4dbfbb2a22e1bbce9bd16a5348add489a23f21d90675c2c89285e3d20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d65940358b2c5cda61f180223799c9edebc462bc9ea8b6f88f31889e62425f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79016a60816e98e920a8280b5deefdcfb22314779d778de6e1c2998cd85c0250"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baef308aca88a55411459531ab9a1dca8a34881d479c88e18cf5ca2623edad71"
    sha256 cellar: :any_skip_relocation, ventura:        "9dc55714537e0eaca2d8858b871e0550f3f83ba381d20eed73ee50c9226cd6b5"
    sha256 cellar: :any_skip_relocation, monterey:       "1bbb622c2aaa58cb3c3a721926f8de5fa478d33e87a8355fd27c8132b6bab26e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4f4d012c550ff9bfb643a70ebdaa4b462516367121881c50e119755bf2d6945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b77bc4de224ec24c6fd83a9aad7f87ce417359dc7b1384b86b198c78c752779b"
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

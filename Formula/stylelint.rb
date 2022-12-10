require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-14.16.0.tgz"
  sha256 "ef21f96e702949ef33651e44f564953641a944d8fa4ae710420fc238163db318"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e57709888a4cca0d61e4237ad9996a24b86dfa924b5c0e8b234adb34ced57223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e57709888a4cca0d61e4237ad9996a24b86dfa924b5c0e8b234adb34ced57223"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e57709888a4cca0d61e4237ad9996a24b86dfa924b5c0e8b234adb34ced57223"
    sha256 cellar: :any_skip_relocation, ventura:        "933d11f3903acebb2ac367b80a85c4ca0a6e27816f8536bf94312086a475e8cb"
    sha256 cellar: :any_skip_relocation, monterey:       "933d11f3903acebb2ac367b80a85c4ca0a6e27816f8536bf94312086a475e8cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "933d11f3903acebb2ac367b80a85c4ca0a6e27816f8536bf94312086a475e8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e57709888a4cca0d61e4237ad9996a24b86dfa924b5c0e8b234adb34ced57223"
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

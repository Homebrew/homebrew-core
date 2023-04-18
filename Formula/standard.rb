require "language/node"

class Standard < Formula
  desc "JavaScript Style Guide, with linter & automatic code fixer"
  homepage "https://standardjs.com/"
  url "https://registry.npmjs.org/standard/-/standard-17.0.0.tgz"
  sha256 "af6ceb9e3d9a61b0ea80ca64164773f7c0b090e04e844a665958ebb03726e79c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef62dc87887accb784bfc125a7acfd8a8a83468d338ad48a35be85c0c6d49b66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef62dc87887accb784bfc125a7acfd8a8a83468d338ad48a35be85c0c6d49b66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef62dc87887accb784bfc125a7acfd8a8a83468d338ad48a35be85c0c6d49b66"
    sha256 cellar: :any_skip_relocation, ventura:        "c13dae235e41306f482abbc1f4fe2a8d40a0abc85ad4b9710a7aaefa7ab8b5f2"
    sha256 cellar: :any_skip_relocation, monterey:       "c13dae235e41306f482abbc1f4fe2a8d40a0abc85ad4b9710a7aaefa7ab8b5f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c13dae235e41306f482abbc1f4fe2a8d40a0abc85ad4b9710a7aaefa7ab8b5f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef62dc87887accb784bfc125a7acfd8a8a83468d338ad48a35be85c0c6d49b66"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_foo = testpath/"foo.js"
    test_foo.write "console.log(\"hello there\")"
    output = shell_output("#{bin}/standard #{test_foo} 2>&1", 1)
    assert_match "Strings must use singlequote. (quotes)", output

    test_bar = testpath/"bar.js"
    test_bar.write "if (name != 'John') { }"
    output = shell_output("#{bin}/standard #{test_bar} 2>&1", 1)
    assert_match "Expected '!==' and instead saw '!='. (eqeqeq)", output
    assert_match "Empty block statement. (no-empty)", output

    assert_match version.to_s, shell_output("#{bin}/standard --version")
  end
end

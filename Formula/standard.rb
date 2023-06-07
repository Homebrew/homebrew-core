require "language/node"

class Standard < Formula
  desc "JavaScript Style Guide, with linter & automatic code fixer"
  homepage "https://standardjs.com/"
  url "https://registry.npmjs.org/standard/-/standard-17.1.0.tgz"
  sha256 "84ce1ab5180ebb73e0a4b56f37b59823aec3ab34a53540c09eeaf533de5aee53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac043f24d6883a01fc0a97c5f65f522b9521635be94b1ee2d90645e5a5c13f11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac043f24d6883a01fc0a97c5f65f522b9521635be94b1ee2d90645e5a5c13f11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac043f24d6883a01fc0a97c5f65f522b9521635be94b1ee2d90645e5a5c13f11"
    sha256 cellar: :any_skip_relocation, ventura:        "c4faa4fdc9b7304c64b9477d83f11810d6f38a300b2bedf4719d6c40e611c60d"
    sha256 cellar: :any_skip_relocation, monterey:       "c4faa4fdc9b7304c64b9477d83f11810d6f38a300b2bedf4719d6c40e611c60d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4faa4fdc9b7304c64b9477d83f11810d6f38a300b2bedf4719d6c40e611c60d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac043f24d6883a01fc0a97c5f65f522b9521635be94b1ee2d90645e5a5c13f11"
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

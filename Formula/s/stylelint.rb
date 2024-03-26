require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.3.1.tgz"
  sha256 "987820a45842016afdb4a74410d2388ab675b152a44c3c6e5a26c509bee76140"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43b52d7079d143150c2b07b064ab6556fce899522ae40428f8f0a502d8f794dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43b52d7079d143150c2b07b064ab6556fce899522ae40428f8f0a502d8f794dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43b52d7079d143150c2b07b064ab6556fce899522ae40428f8f0a502d8f794dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3a91d15b47a2311813e0e854b6ddd795ee0c8f2bf583af01b24979a0c4e1f7e"
    sha256 cellar: :any_skip_relocation, ventura:        "b3a91d15b47a2311813e0e854b6ddd795ee0c8f2bf583af01b24979a0c4e1f7e"
    sha256 cellar: :any_skip_relocation, monterey:       "b3a91d15b47a2311813e0e854b6ddd795ee0c8f2bf583af01b24979a0c4e1f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b52d7079d143150c2b07b064ab6556fce899522ae40428f8f0a502d8f794dd"
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

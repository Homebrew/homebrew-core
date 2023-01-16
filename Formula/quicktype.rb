require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-20.0.20.tgz"
  sha256 "9efd98dc268feadc0d7997319188af8d897300703fc05b4013c9fd50ae3794f8"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9acd4b602597882c2f44812997da9bcaf47df9f7b24be284214d162f677b227a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9acd4b602597882c2f44812997da9bcaf47df9f7b24be284214d162f677b227a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9acd4b602597882c2f44812997da9bcaf47df9f7b24be284214d162f677b227a"
    sha256 cellar: :any_skip_relocation, ventura:        "b4bbab5ad124417ad6425a05b3096156c15cc7c32117aedae46db4a8608a8f9b"
    sha256 cellar: :any_skip_relocation, monterey:       "b4bbab5ad124417ad6425a05b3096156c15cc7c32117aedae46db4a8608a8f9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4bbab5ad124417ad6425a05b3096156c15cc7c32117aedae46db4a8608a8f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9acd4b602597882c2f44812997da9bcaf47df9f7b24be284214d162f677b227a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end

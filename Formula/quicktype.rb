require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-21.0.10.tgz"
  sha256 "9f38ffa1ca86ce9e76f707730e3f6e3268310c75e74ba19e473e5a36b4055f17"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73b127fd5dd8195c76ade0f6bdefc5c91c16ab35b29b8adf323e073e26bba8f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73b127fd5dd8195c76ade0f6bdefc5c91c16ab35b29b8adf323e073e26bba8f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73b127fd5dd8195c76ade0f6bdefc5c91c16ab35b29b8adf323e073e26bba8f7"
    sha256 cellar: :any_skip_relocation, ventura:        "0cedb99b71ed06707994572276b4778d0933ca80ce342f31560b982e29cba369"
    sha256 cellar: :any_skip_relocation, monterey:       "0cedb99b71ed06707994572276b4778d0933ca80ce342f31560b982e29cba369"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cedb99b71ed06707994572276b4778d0933ca80ce342f31560b982e29cba369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73b127fd5dd8195c76ade0f6bdefc5c91c16ab35b29b8adf323e073e26bba8f7"
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

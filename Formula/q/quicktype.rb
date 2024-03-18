require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.107.tgz"
  sha256 "755b9814c79752989545689fbb685687d9e04bbd4d2e84bd4cea795e4e878325"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c3961ff2202f0c4c24f1adca70c40c9ae1e35ab1e00e9a9f54dffd12b96982d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c3961ff2202f0c4c24f1adca70c40c9ae1e35ab1e00e9a9f54dffd12b96982d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c3961ff2202f0c4c24f1adca70c40c9ae1e35ab1e00e9a9f54dffd12b96982d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a2fdd09024bf449f61352487cbb20b949b6e1dd2320c7a993879ee599066b28"
    sha256 cellar: :any_skip_relocation, ventura:        "1a2fdd09024bf449f61352487cbb20b949b6e1dd2320c7a993879ee599066b28"
    sha256 cellar: :any_skip_relocation, monterey:       "1a2fdd09024bf449f61352487cbb20b949b6e1dd2320c7a993879ee599066b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c3961ff2202f0c4c24f1adca70c40c9ae1e35ab1e00e9a9f54dffd12b96982d"
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
